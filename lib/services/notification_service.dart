import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_festivals.dart';
import '../screens/main_navigation_screen.dart';

/// Notification Service for scheduled devotional morning/evening prayers,
/// festival alerts, and Aarti reminders with elderly-friendly contextual messages.
class NotificationService {
  static const int morningReminderId = 1001;
  static const int eveningReminderId = 1002;
  static const int testReminderId = 1003;
  static const int brahmaMuhurtaId = 101;
  static const int _reminderDaysToSchedule = 7;

  static const String channelId = 'devavani_daily_reminders';
  static const String channelName = 'दैनिक प्रार्थना व आरती स्मरण';
  static const String channelDescription =
      'सुबह और शाम की पावन आरती, चालीसा व दैनिक प्रार्थना स्मरण';

  static const String aartiPayload = 'aarti';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final bool _enablePlatform;
  final List<PendingNotificationRequest> _testPending = [];

  bool _isInitialized = false;

  NotificationService({bool enablePlatformNotifications = true})
    : _enablePlatform = enablePlatformNotifications;

  bool get _isPlatformAvailable {
    if (!_enablePlatform || kIsWeb) return false;
    try {
      final binding = WidgetsBinding.instance;
      if (binding.runtimeType.toString().contains('Test')) {
        return false;
      }
    } catch (_) {}
    return true;
  }

  /// Optional custom callback when a notification response is received
  void Function(String? payload)? onNotificationTapped;

  Future<void> init({void Function(String? payload)? onTapped}) async {
    if (onTapped != null) {
      onNotificationTapped = onTapped;
    }

    if (_isInitialized) return;

    if (!_isPlatformAvailable) {
      _isInitialized = true;
      return;
    }

    try {
      // Initialize timezone database
      tz.initializeTimeZones();
      try {
        final String localName = DateTime.now().timeZoneName;
        // Default to Asia/Kolkata if available, else local
        final location = tz.getLocation(localName);
        tz.setLocalLocation(location);
      } catch (_) {
        // Fallback safely to Asia/Kolkata (IST standard for Devavani users)
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
        } catch (_) {
          tz.setLocalLocation(tz.local);
        }
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Devavani Notification clicked: ${response.payload}');
          _handleNotificationTap(response.payload);
        },
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  void _handleNotificationTap(String? payload) {
    onNotificationTapped?.call(payload);
    if (payload == aartiPayload) {
      // Open Aarti screen (Tab 1 in MainNavigationScreen)
      MainNavigationController.navigateToTab(1);
    }
  }

  /// Request notification permissions (required on Android 13+ and iOS)
  Future<bool> requestPermissions() async {
    if (!_isPlatformAvailable) return true;
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        final bool? granted = await androidImplementation
            .requestNotificationsPermission();
        return granted ?? true;
      }
      return true;
    } catch (e) {
      debugPrint('Notification permissions requested (fallback): $e');
      return true;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Contextual Daily Message Generator
  // ─────────────────────────────────────────────────────────────────────────

  /// Generates contextual devotional messages based on:
  /// 1. Active Festival (Highest Priority)
  /// 2. Day of the Week (Second Priority)
  /// 3. Morning vs Evening phrasing
  /// 4. Selected Language ('hi', 'ne', 'en')
  static ({String title, String body}) getContextualReminder({
    required DateTime date,
    required bool isEvening,
    required String lang,
  }) {
    // 1. Check for Active Festival first (Highest Precedence)
    final festival = AppFestivals.getActiveFestival(date);
    if (festival != null) {
      return _generateFestivalMessage(
        festivalId: festival.id,
        isEvening: isEvening,
        lang: lang,
      );
    }

    // 2. Fall back to Day of the Week
    return _generateWeekdayMessage(
      weekday: date.weekday,
      isEvening: isEvening,
      lang: lang,
    );
  }

  static ({String title, String body}) _generateFestivalMessage({
    required String festivalId,
    required bool isEvening,
    required String lang,
  }) {
    switch (lang) {
      case 'ne':
        final title = isEvening
            ? '🪔 सन्ध्या स्मरण • पावन पर्व'
            : '🌅 प्रातः स्मरण • पावन पर्व';
        switch (festivalId) {
          case 'mahashivratri':
            return (
              title: title,
              body: isEvening
                  ? '🔱 आज महाशिवरात्रिको पावन सन्ध्या हो। भगवान शिवको आरती गरौँ। 🙏'
                  : '🔱 आज महाशिवरात्रि हो। भगवान शिवको आरती र आजको तिथि हेर्नुहोस्। 🙏',
            );
          case 'hanuman_jayanti':
            return (
              title: title,
              body:
                  '🚩 आज हनुमान जयन्ती हो। सङ्कटमोचन हनुमान जीको आरती र चालीसा पाठ गरौँ। 🙏',
            );
          case 'ganesh_chaturthi':
            return (
              title: title,
              body:
                  '🐘 आज गणेश चतुर्थी हो। विघ्नहर्ता गणपति बप्पाको आरती गरौँ। 🙏',
            );
          case 'navratri':
            return (
              title: title,
              body:
                  '🌺 आज पावन नवरात्रि हो। माँ दुर्गाको आरती र स्तुति गरौँ। 🙏',
            );
          case 'janmashtami':
            return (
              title: title,
              body:
                  '🦚 आज श्रीकृष्ण जन्माष्टमी हो। भगवान श्री कृष्णको आरती गरौँ। 🙏',
            );
          case 'ram_navami':
            return (
              title: title,
              body:
                  '🏹 आज पावन रामनवमी हो। प्रभु श्री रामको आरती र वन्दना गरौँ। 🙏',
            );
          case 'diwali':
            return (
              title: title,
              body:
                  '🪔 आज दीपावलीको पावन पर्व हो। माता लक्ष्मी र श्री रामको आरती गरौँ। 🙏',
            );
          default:
            return (
              title: title,
              body: '🙏 आज पावन पर्व हो। प्रभुको ध्यान र आरती गरौँ। ॐ शान्ति।',
            );
        }

      case 'en':
        final title = isEvening
            ? '🪔 Evening Devotion • Holy Festival'
            : '🌅 Morning Devotion • Holy Festival';
        switch (festivalId) {
          case 'mahashivratri':
            return (
              title: title,
              body: isEvening
                  ? '🔱 Tonight is Mahashivratri. Offer prayers and view Lord Shiva\'s Aarti. 🙏'
                  : '🔱 Today is Mahashivratri. Offer prayers and view Lord Shiva\'s Aarti. 🙏',
            );
          case 'hanuman_jayanti':
            return (
              title: title,
              body:
                  '🚩 Today is Hanuman Jayanti. Recite Hanuman Chalisa and perform Aarti. 🙏',
            );
          case 'ganesh_chaturthi':
            return (
              title: title,
              body:
                  '🐘 Today is Ganesh Chaturthi. Worship Lord Ganesha with holy Aarti. 🙏',
            );
          case 'navratri':
            return (
              title: title,
              body:
                  '🌺 Today is auspicious Navratri. Offer prayers and Maa Durga\'s Aarti. 🙏',
            );
          case 'janmashtami':
            return (
              title: title,
              body:
                  '🦚 Today is Janmashtami. Celebrate Lord Krishna\'s divine Aarti. 🙏',
            );
          case 'ram_navami':
            return (
              title: title,
              body:
                  '🏹 Today is Ram Navami. Recite Lord Ram\'s sacred prayer and Aarti. 🙏',
            );
          case 'diwali':
            return (
              title: title,
              body:
                  '🪔 Today is Diwali. Light holy lamps and join the divine evening Aarti. 🙏',
            );
          default:
            return (
              title: title,
              body:
                  '🙏 Today is a sacred festival. Offer devotion and join the Aarti. ॐ',
            );
        }

      case 'hi':
      default:
        final title = isEvening
            ? '🪔 संध्या स्मरण • पावन पर्व'
            : '🌅 प्रातः स्मरण • पावन पर्व';
        switch (festivalId) {
          case 'mahashivratri':
            return (
              title: title,
              body: isEvening
                  ? '🔱 आज महाशिवरात्रि की पावन संध्या है। भगवान शिव की आरती और ध्यान करें। 🙏'
                  : '🔱 आज महाशिवरात्रि है। भगवान शिव की आरती और आज की तिथि देखें। 🙏',
            );
          case 'hanuman_jayanti':
            return (
              title: title,
              body:
                  '🚩 आज हनुमान जयंती है। संकटमोचन हनुमान जी की आरती व चालीसा का पाठ करें। 🙏',
            );
          case 'ganesh_chaturthi':
            return (
              title: title,
              body:
                  '🐘 आज गणेश चतुर्थी है। विघ्नहर्ता गणपति बप्पा की आरती करें। 🙏',
            );
          case 'navratri':
            return (
              title: title,
              body:
                  '🌺 आज पावन नवरात्रि है। माँ भगवती दुर्गा जी की आरती व स्तुति करें। 🙏',
            );
          case 'janmashtami':
            return (
              title: title,
              body:
                  '🦚 आज श्रीकृष्ण जन्माष्टमी है। बाल गोपाल भगवान श्री कृष्ण की आरती करें। 🙏',
            );
          case 'ram_navami':
            return (
              title: title,
              body:
                  '🏹 आज पावन रामनवमी है। मर्यादा पुरुषोत्तम प्रभु श्री राम की आरती करें। 🙏',
            );
          case 'diwali':
            return (
              title: title,
              body:
                  '🪔 आज दीपावली का पावन महापर्व है। माता लक्ष्मी व प्रभु श्री राम की आरती करें। 🙏',
            );
          case 'makar_sankranti':
            return (
              title: title,
              body:
                  '☀️ आज मकर संक्रांति है। सूर्य देव व प्रभु श्री राम का ध्यान और आरती करें। 🙏',
            );
          default:
            return (
              title: title,
              body:
                  '🙏 आज पावन धार्मिक पर्व है। आइए श्रद्धाभाव से आज की आरती करें। ॐ',
            );
        }
    }
  }

  static ({String title, String body}) _generateWeekdayMessage({
    required int weekday,
    required bool isEvening,
    required String lang,
  }) {
    switch (lang) {
      case 'ne':
        final title = isEvening
            ? '🪔 सन्ध्या स्मरण • शुभ सन्ध्या'
            : '🌅 प्रातः स्मरण • शुभ प्रभात';
        switch (weekday) {
          case DateTime.monday:
            return (
              title: title,
              body: isEvening
                  ? '🔱 आज सोमबारको पावन सन्ध्या हो। भगवान शिवको आरती गरौँ। 🙏'
                  : '🔱 आज सोमबार हो। आउनुहोस् भगवान शिवको आरती गरौँ। 🙏',
            );
          case DateTime.tuesday:
            return (
              title: title,
              body: isEvening
                  ? '🚩 आज मङ्गलबारको शुभ सन्ध्या हो। सङ्कटमोचन हनुमान जीको आरती गरौँ। 🙏'
                  : '🚩 आज मङ्गलबार हो। हनुमान जीको आरतीका साथ दिनको सुरुवात गरौँ।',
            );
          case DateTime.wednesday:
            return (
              title: title,
              body:
                  '🐘 आज बुधबार हो। विघ्नहर्ता श्री गणेश जीको आरती र वन्दना गरौँ। 🙏',
            );
          case DateTime.thursday:
            return (
              title: title,
              body: '🪷 आज बिहीबार हो। भगवान श्री हरि विष्णुको आरती गरौँ। 🙏',
            );
          case DateTime.friday:
            return (
              title: title,
              body: '🌺 आज शुक्रबार हो। माँ भगवती दुर्गाको पावन आरती गरौँ। 🙏',
            );
          case DateTime.saturday:
            return (
              title: title,
              body:
                  '🪐 आज शनिबार हो। सङ्कटमोचन हनुमान जी र शनि देवको आरती गरौँ। 🙏',
            );
          case DateTime.sunday:
          default:
            return (
              title: title,
              body:
                  '☀️ आज आइतबार हो। भगवान सूर्य देव र प्रभु श्री रामको स्तुति गरौँ। 🙏',
            );
        }

      case 'en':
        final title = isEvening
            ? '🪔 Evening Devotion • Holy Aarti'
            : '🌅 Morning Devotion • Start Your Day';
        switch (weekday) {
          case DateTime.monday:
            return (
              title: title,
              body: isEvening
                  ? '🔱 Monday evening prayer. Let us perform Lord Shiva\'s Aarti together. 🙏'
                  : '🔱 Today is Monday. Let us perform Lord Shiva\'s Aarti. 🙏',
            );
          case DateTime.tuesday:
            return (
              title: title,
              body: isEvening
                  ? '🚩 Tuesday evening prayer. Conclude your day with Hanuman Ji\'s Aarti. 🙏'
                  : '🚩 Today is Tuesday. Start your day with Hanuman Ji\'s Aarti.',
            );
          case DateTime.wednesday:
            return (
              title: title,
              body:
                  '🐘 Today is Wednesday. Recite Lord Ganesha\'s Aarti for wisdom & peace. 🙏',
            );
          case DateTime.thursday:
            return (
              title: title,
              body:
                  '🪷 Today is Thursday. Offer heartfelt Aarti to Lord Vishnu. 🙏',
            );
          case DateTime.friday:
            return (
              title: title,
              body:
                  '🌺 Today is Friday. Offer Aarti and prayers to Goddess Durga. 🙏',
            );
          case DateTime.saturday:
            return (
              title: title,
              body:
                  '🪐 Today is Saturday. Seek blessings with Hanuman Ji\'s & Shani Dev\'s Aarti. 🙏',
            );
          case DateTime.sunday:
          default:
            return (
              title: title,
              body:
                  '☀️ Today is Sunday. Praise Lord Surya and Lord Ram with holy Aarti. 🙏',
            );
        }

      case 'hi':
      default:
        final title = isEvening
            ? '🪔 संध्या स्मरण • शुभ संध्या'
            : '🌅 प्रातः स्मरण • शुभ प्रभात';
        switch (weekday) {
          case DateTime.monday:
            return (
              title: title,
              body: isEvening
                  ? '🔱 आज सोमवार की पावन संध्या है। भगवान शिव की आरती से दिन का समापन करें। 🙏'
                  : '🔱 आज सोमवार है। आइए भगवान शिव की आरती करें। 🙏',
            );
          case DateTime.tuesday:
            return (
              title: title,
              body: isEvening
                  ? '🚩 आज मंगलवार की शुभ संध्या है। संकटमोचन हनुमान जी की आरती करें। 🙏'
                  : '🚩 आज मंगलवार है। हनुमान जी की आरती के साथ दिन की शुरुआत करें।',
            );
          case DateTime.wednesday:
            return (
              title: title,
              body: isEvening
                  ? '🐘 आज बुधवार की शुभ संध्या है। श्री गणेश जी की आरती में सम्मिलित हों। 🙏'
                  : '🐘 आज बुधवार है। विघ्नहर्ता श्री गणेश जी की आरती व वंदना करें। 🙏',
            );
          case DateTime.thursday:
            return (
              title: title,
              body: isEvening
                  ? '🪷 आज गुरुवार की शुभ संध्या है। भगवान श्री हरि विष्णु की आरती करें। 🙏'
                  : '🪷 आज गुरुवार है। भगवान श्री हरि विष्णु की आरती करें। 🙏',
            );
          case DateTime.friday:
            return (
              title: title,
              body: isEvening
                  ? '🌺 आज शुक्रवार की शुभ संध्या है। माँ भगवती की संध्या आरती करें। 🙏'
                  : '🌺 आज शुक्रवार है। माँ भगवती दुर्गा जी का स्मरण और आरती करें। 🙏',
            );
          case DateTime.saturday:
            return (
              title: title,
              body: isEvening
                  ? '🪐 आज शनिवार की शुभ संध्या है। हनुमान जी व शनि देव की आरती करें। 🙏'
                  : '🪐 आज शनिवार है। संकटमोचन हनुमान जी व शनि देव की आरती करें। 🙏',
            );
          case DateTime.sunday:
          default:
            return (
              title: title,
              body: isEvening
                  ? '☀️ आज रविवार की शुभ संध्या है। प्रभु श्री राम की संध्या आरती करें। 🙏'
                  : '☀️ आज रविवार है। भगवान सूर्य देव व श्री राम की पावन आरती करें। 🙏',
            );
        }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Scheduling Logic
  // ─────────────────────────────────────────────────────────────────────────

  /// Schedules morning reminders for the next seven days.
  Future<bool> scheduleDailyMorningReminder({
    required int hour,
    required int minute,
    required String lang,
  }) async {
    return _scheduleDailyZoned(
      id: morningReminderId,
      hour: hour,
      minute: minute,
      isEvening: false,
      lang: lang,
    );
  }

  /// Schedules evening reminders for the next seven days.
  Future<bool> scheduleDailyEveningReminder({
    required int hour,
    required int minute,
    required String lang,
  }) async {
    return _scheduleDailyZoned(
      id: eveningReminderId,
      hour: hour,
      minute: minute,
      isEvening: true,
      lang: lang,
    );
  }

  /// Schedules ordinary one-time notifications instead of a repeating alarm.
  /// This is more compatible with Android vendor battery and alarm managers.
  Future<bool> _scheduleDailyZoned({
    required int id,
    required int hour,
    required int minute,
    required bool isEvening,
    required String lang,
  }) async {
    if (!_isPlatformAvailable) {
      _testPending.removeWhere((p) => p.id == id);
      final scheduledDate = _nextInstanceOfTime(hour, minute);
      final msg = getContextualReminder(
        date: scheduledDate,
        isEvening: isEvening,
        lang: lang,
      );
      _testPending.add(
        PendingNotificationRequest(id, msg.title, msg.body, aartiPayload),
      );
      return true;
    }

    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.reminder,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      final scheduleMode = await _getScheduleMode();

      await _cancelReminderSeries(id);
      final firstDate = _nextInstanceOfTime(hour, minute);

      for (var day = 0; day < _reminderDaysToSchedule; day++) {
        final scheduledDate = firstDate.add(Duration(days: day));
        final notificationId = id + (day * 10);
        final msg = getContextualReminder(
          date: scheduledDate,
          isEvening: isEvening,
          lang: lang,
        );

        await _notificationsPlugin.zonedSchedule(
          id: notificationId,
          title: msg.title,
          body: msg.body,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: scheduleMode,
          payload: aartiPayload,
        );
      }

      debugPrint(
        'Devavani: Scheduled $_reminderDaysToSchedule reminders for $id at $hour:$minute',
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService _scheduleDailyZoned error: $e');
      return false;
    }
  }

  Future<AndroidScheduleMode> _getScheduleMode() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation == null) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }

    try {
      final canScheduleExact = await androidImplementation
          .canScheduleExactNotifications();
      return canScheduleExact == true
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (e) {
      debugPrint('Devavani: Exact alarm check unavailable: $e');
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  Future<void> _cancelReminderSeries(int baseId) async {
    for (var day = 0; day < _reminderDaysToSchedule; day++) {
      await _notificationsPlugin.cancel(id: baseId + (day * 10));
    }
  }

  /// Safely resolves the active timezone location, initializing if needed.
  tz.Location _safeLocation() {
    try {
      return tz.local;
    } catch (_) {
      try {
        tz.initializeTimeZones();
        final loc = tz.getLocation('Asia/Kolkata');
        tz.setLocalLocation(loc);
        return loc;
      } catch (_) {
        return tz.UTC;
      }
    }
  }

  /// Calculates the next tz.TZDateTime for the given hour and minute.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final loc = _safeLocation();
    final tz.TZDateTime now = tz.TZDateTime.now(loc);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      loc,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Cancels the scheduled morning reminder
  Future<void> cancelMorningReminder() async {
    if (!_isPlatformAvailable) {
      _testPending.removeWhere((p) => p.id == morningReminderId);
      return;
    }
    try {
      await _cancelReminderSeries(morningReminderId);
      debugPrint('Devavani: Cancelled morning reminder');
    } catch (e) {
      debugPrint('Error cancelling morning reminder: $e');
    }
  }

  /// Cancels the scheduled evening reminder
  Future<void> cancelEveningReminder() async {
    if (!_isPlatformAvailable) {
      _testPending.removeWhere((p) => p.id == eveningReminderId);
      return;
    }
    try {
      await _cancelReminderSeries(eveningReminderId);
      debugPrint('Devavani: Cancelled evening reminder');
    } catch (e) {
      debugPrint('Error cancelling evening reminder: $e');
    }
  }

  /// Cancels all scheduled reminders
  Future<void> cancelAllReminders() async {
    if (!_isPlatformAvailable) {
      _testPending.clear();
      return;
    }
    try {
      await _cancelReminderSeries(morningReminderId);
      await _cancelReminderSeries(eveningReminderId);
    } catch (e) {
      debugPrint('Error cancelling all reminders: $e');
    }
  }

  /// Returns all currently pending notification requests (useful for tests and verification)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isPlatformAvailable) {
      return List.unmodifiable(_testPending);
    }
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Immediately shows a test reminder notification
  /// Useful for elderly users to see how the notification looks and verify sound/vibration
  Future<void> showTestReminder({
    required bool isEvening,
    required String lang,
  }) async {
    try {
      final now = DateTime.now();
      final msg = getContextualReminder(
        date: now,
        isEvening: isEvening,
        lang: lang,
      );

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.reminder,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        id: testReminderId,
        title: '🔔 ${msg.title}',
        body: msg.body,
        notificationDetails: details,
        payload: aartiPayload,
      );
    } catch (e) {
      debugPrint('Error showing test reminder: $e');
    }
  }

  /// Shows immediate devotional notification reminder (e.g. for Brahma Muhurta toggle)
  Future<void> showDevotionalReminder({
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'devavani_prayers_channel',
            'दैनिक प्रार्थना व ब्रह्म मुहूर्त',
            channelDescription: 'दैनिक आरती, जाप और पंचांग स्मरण सूचनाएं',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.show(
        id: brahmaMuhurtaId,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: aartiPayload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
