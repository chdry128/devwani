import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// Global app settings provider (Language, Morning/Evening Daily Reminders, preferences)
class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;

  /// Optional callback fired when language changes — used to sync PanchangProvider
  /// without creating a circular dependency.
  void Function(String lang)? onLanguageChanged;

  late String _language;
  bool _brahmaMuhurtaEnabled = true;
  bool _showBannerAds = true;
  late List<String> _selectedDeities;

  // Daily Reminders State
  late bool _morningReminderEnabled;
  late int _morningHour;
  late int _morningMinute;

  late bool _eveningReminderEnabled;
  late int _eveningHour;
  late int _eveningMinute;

  SettingsProvider(this._storageService, this._notificationService) {
    _language = _storageService.getLanguage();
    _selectedDeities = _storageService.getSelectedDeities();

    // Load reminder preferences
    _morningReminderEnabled = _storageService.getMorningReminderEnabled();
    _morningHour = _storageService.getMorningReminderHour();
    _morningMinute = _storageService.getMorningReminderMinute();

    _eveningReminderEnabled = _storageService.getEveningReminderEnabled();
    _eveningHour = _storageService.getEveningReminderHour();
    _eveningMinute = _storageService.getEveningReminderMinute();

    // Re-schedule active reminders in background if already enabled
    _rescheduleActiveReminders();
  }

  String get language => _language;
  bool get brahmaMuhurtaEnabled => _brahmaMuhurtaEnabled;
  bool get showBannerAds => _showBannerAds;

  // Reminders Getters
  bool get morningReminderEnabled => _morningReminderEnabled;
  int get morningHour => _morningHour;
  int get morningMinute => _morningMinute;

  bool get eveningReminderEnabled => _eveningReminderEnabled;
  int get eveningHour => _eveningHour;
  int get eveningMinute => _eveningMinute;

  /// Deities the user chose during onboarding (IDs like 'hanuman', 'ganesha').
  List<String> get selectedDeities => List.unmodifiable(_selectedDeities);

  Future<void> setSelectedDeities(List<String> deities) async {
    _selectedDeities = List.of(deities);
    await _storageService.saveSelectedDeities(deities);
    notifyListeners();
  }

  Future<void> setLanguage(String newLang) async {
    if (_language != newLang) {
      _language = newLang;
      await _storageService.saveLanguage(newLang);
      await _rescheduleActiveReminders();
      onLanguageChanged?.call(newLang);
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Morning Reminder Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Updates morning reminder state and schedules or cancels notification.
  /// If [enabled] is true, checks for user notification permission first.
  Future<bool> setMorningReminder(
    bool enabled, {
    int? hour,
    int? minute,
  }) async {
    if (hour != null) {
      _morningHour = hour;
      await _storageService.saveMorningReminderHour(hour);
    }
    if (minute != null) {
      _morningMinute = minute;
      await _storageService.saveMorningReminderMinute(minute);
    }

    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        _morningReminderEnabled = false;
        await _storageService.saveMorningReminderEnabled(false);
        notifyListeners();
        return false;
      }

      // Ensure notification service is initialized
      await _notificationService.init();

      _morningReminderEnabled = true;
      await _storageService.saveMorningReminderEnabled(true);
      await _notificationService.scheduleDailyMorningReminder(
        hour: _morningHour,
        minute: _morningMinute,
        lang: _language,
      );
    } else {
      _morningReminderEnabled = false;
      await _storageService.saveMorningReminderEnabled(false);
      await _notificationService.cancelMorningReminder();
    }

    notifyListeners();
    return true;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Evening Reminder Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Updates evening reminder state and schedules or cancels notification.
  /// If [enabled] is true, checks for user notification permission first.
  Future<bool> setEveningReminder(
    bool enabled, {
    int? hour,
    int? minute,
  }) async {
    if (hour != null) {
      _eveningHour = hour;
      await _storageService.saveEveningReminderHour(hour);
    }
    if (minute != null) {
      _eveningMinute = minute;
      await _storageService.saveEveningReminderMinute(minute);
    }

    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        _eveningReminderEnabled = false;
        await _storageService.saveEveningReminderEnabled(false);
        notifyListeners();
        return false;
      }

      // Ensure notification service is initialized
      await _notificationService.init();

      _eveningReminderEnabled = true;
      await _storageService.saveEveningReminderEnabled(true);
      await _notificationService.scheduleDailyEveningReminder(
        hour: _eveningHour,
        minute: _eveningMinute,
        lang: _language,
      );
    } else {
      _eveningReminderEnabled = false;
      await _storageService.saveEveningReminderEnabled(false);
      await _notificationService.cancelEveningReminder();
    }

    notifyListeners();
    return true;
  }

  /// Re-schedules whichever reminders are currently enabled
  Future<void> _rescheduleActiveReminders() async {
    // Ensure notification service is ready before any scheduling
    await _notificationService.init();
    if (_morningReminderEnabled) {
      await _notificationService.scheduleDailyMorningReminder(
        hour: _morningHour,
        minute: _morningMinute,
        lang: _language,
      );
    }
    if (_eveningReminderEnabled) {
      await _notificationService.scheduleDailyEveningReminder(
        hour: _eveningHour,
        minute: _eveningMinute,
        lang: _language,
      );
    }
  }

  /// Immediately triggers a test reminder notification
  Future<void> sendTestReminder({required bool isEvening}) async {
    await _notificationService.requestPermissions();
    await _notificationService.showTestReminder(
      isEvening: isEvening,
      lang: _language,
    );
  }

  Future<void> toggleBrahmaMuhurta() async {
    _brahmaMuhurtaEnabled = !_brahmaMuhurtaEnabled;
    if (_brahmaMuhurtaEnabled) {
      await _notificationService.requestPermissions();
      await _notificationService.showDevotionalReminder(
        title: 'ब्रह्म मुहूर्त स्मरण सक्रिय',
        body: 'प्रातः 05:00 बजे दैनिक आरती व ध्यान की सूचना दी जाएगी।',
      );
    }
    notifyListeners();
  }

  void toggleBannerAds() {
    _showBannerAds = !_showBannerAds;
    notifyListeners();
  }
}
