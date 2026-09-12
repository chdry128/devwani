import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:devavani/providers/audio_provider.dart';
import 'package:devavani/providers/jaap_provider.dart';
import 'package:devavani/providers/panchang_provider.dart';
import 'package:devavani/providers/settings_provider.dart';
import 'package:devavani/screens/home_screen.dart';
import 'package:devavani/screens/settings_screen.dart';
import 'package:devavani/services/audio_player_service.dart';
import 'package:devavani/services/notification_service.dart';
import 'package:devavani/services/storage_service.dart';

Widget createTestApp(
  Widget child, {
  required StorageService storage,
  required AudioPlayerService audio,
  required NotificationService notifications,
}) {
  return MultiProvider(
    providers: [
      Provider<StorageService>.value(value: storage),
      Provider<AudioPlayerService>.value(value: audio),
      Provider<NotificationService>.value(value: notifications),
      ChangeNotifierProvider<JaapProvider>(
        create: (_) => JaapProvider(storage, audio),
      ),
      ChangeNotifierProvider<AudioProvider>(
        create: (_) => AudioProvider(audio, storage),
      ),
      ChangeNotifierProvider<PanchangProvider>(
        create: (_) => PanchangProvider(),
      ),
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(storage, notifications),
      ),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Contextual Messages Tests', () {
    test('Priority 2: Normal weekday generates correct deity message (Monday & Tuesday)', () {
      // Monday (1)
      final mondayDate = DateTime(2026, 6, 1); // Monday, not a festival
      expect(mondayDate.weekday, DateTime.monday);

      final mondayMsg = NotificationService.getContextualReminder(
        date: mondayDate,
        isEvening: false,
        lang: 'hi',
      );
      expect(mondayMsg.body, contains('सोमवार'));
      expect(mondayMsg.body, contains('भगवान शिव'));

      // Tuesday (2)
      final tuesdayDate = DateTime(2026, 6, 2); // Tuesday
      expect(tuesdayDate.weekday, DateTime.tuesday);

      final tuesdayMsg = NotificationService.getContextualReminder(
        date: tuesdayDate,
        isEvening: false,
        lang: 'hi',
      );
      expect(tuesdayMsg.body, contains('मंगलवार'));
      expect(tuesdayMsg.body, contains('हनुमान जी'));
    });

    test('Priority 1: Active Festival takes highest precedence over normal weekday', () {
      // Mahashivratri is on March 1 (approximateMonth: 3, approximateDay: 1)
      final shivratriDate = DateTime(2026, 3, 1);
      final msg = NotificationService.getContextualReminder(
        date: shivratriDate,
        isEvening: false,
        lang: 'hi',
      );

      // Should be Mahashivratri message, regardless of day of week
      expect(msg.body, contains('महाशिवरात्रि'));
      expect(msg.title, contains('पावन पर्व'));
    });

    test('Tri-lingual support for notifications (Hindi, Nepali, English)', () {
      final date = DateTime(2026, 6, 1); // Monday

      final hiMsg = NotificationService.getContextualReminder(
        date: date,
        isEvening: false,
        lang: 'hi',
      );
      final neMsg = NotificationService.getContextualReminder(
        date: date,
        isEvening: false,
        lang: 'ne',
      );
      final enMsg = NotificationService.getContextualReminder(
        date: date,
        isEvening: false,
        lang: 'en',
      );

      expect(hiMsg.body, contains('सोमवार'));
      expect(neMsg.body, contains('सोमबार'));
      expect(enMsg.body, contains('Monday'));
    });

    test('Evening phrasing is respectful and appropriate for twilight prayers', () {
      final date = DateTime(2026, 6, 1); // Monday
      final eveningMsg = NotificationService.getContextualReminder(
        date: date,
        isEvening: true,
        lang: 'hi',
      );

      expect(eveningMsg.title, contains('संध्या स्मरण'));
      expect(eveningMsg.body, contains('संध्या'));
    });
  });

  group('StorageService & SettingsProvider Reminders Persistence', () {
    late StorageService storage;
    late NotificationService notifications;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      notifications = NotificationService();
    });

    test('StorageService persists morning and evening reminder settings', () async {
      expect(storage.getMorningReminderEnabled(), false);
      expect(storage.getEveningReminderEnabled(), false);

      await storage.saveMorningReminderEnabled(true);
      await storage.saveMorningReminderHour(6);
      await storage.saveMorningReminderMinute(30);

      expect(storage.getMorningReminderEnabled(), true);
      expect(storage.getMorningReminderHour(), 6);
      expect(storage.getMorningReminderMinute(), 30);

      await storage.saveEveningReminderEnabled(true);
      await storage.saveEveningReminderHour(18);
      await storage.saveEveningReminderMinute(45);

      expect(storage.getEveningReminderEnabled(), true);
      expect(storage.getEveningReminderHour(), 18);
      expect(storage.getEveningReminderMinute(), 45);
    });

    test('SettingsProvider updates and loads language and reminders', () async {
      final provider = SettingsProvider(storage, notifications);

      expect(provider.language, 'hi');
      await provider.setLanguage('ne');
      expect(provider.language, 'ne');
      expect(storage.getLanguage(), 'ne');

      await provider.setMorningReminder(true, hour: 8, minute: 0);
      expect(provider.morningReminderEnabled, true);
      expect(provider.morningHour, 8);
      expect(provider.morningMinute, 0);

      await provider.setEveningReminder(true, hour: 20, minute: 15);
      expect(provider.eveningReminderEnabled, true);
      expect(provider.eveningHour, 20);
      expect(provider.eveningMinute, 15);
    });
  });

  group('SettingsScreen UI & Navigation Tests', () {
    late StorageService storage;
    late AudioPlayerService audio;
    late NotificationService notifications;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      audio = AudioPlayerService(enablePlatformAudio: false);
      notifications = NotificationService();
    });

    testWidgets('SettingsScreen renders title, 3 language options, and reminders', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      // Screen title
      expect(find.text('सेटिंग्स / मेरी प्राथमिकताएँ'), findsOneWidget);

      // 3 Language options
      expect(find.text('हिन्दी'), findsOneWidget);
      expect(find.text('नेपाली'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Section 2: Daily Reminders
      expect(find.text('दैनिक स्मरण (Daily Reminders)'), findsOneWidget);
      expect(find.text('सुबह का स्मरण'), findsOneWidget);
      expect(find.text('शाम का स्मरण'), findsOneWidget);

      // Notice
      expect(find.text('सम्मानजनक व शांत स्मरण नीति'), findsOneWidget);
    });

    testWidgets('Tapping a language option updates active language', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      // Tap English option
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // Title should now update to English!
      expect(find.text('Settings / My Preferences'), findsOneWidget);
      expect(find.text('Morning Reminder'), findsOneWidget);
      expect(find.text('Evening Reminder'), findsOneWidget);
    });

    testWidgets('Toggling morning reminder reveals time presets and preview', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      // Find first switch (morning reminder)
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(2));

      // Toggle morning reminder on
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      // Presets should now appear
      expect(find.text('06:00 AM'), findsOneWidget);
      expect(find.text('07:00 AM'), findsNWidgets(2));
      expect(find.text('08:00 AM'), findsOneWidget);
      expect(find.text('अन्य समय...'), findsOneWidget);

      // Message preview box should appear
      expect(find.text('आज का पावन संदेश (पूर्वावलोकन)'), findsOneWidget);
    });

    testWidgets('Account icon in HomeScreen opens SettingsScreen', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          HomeScreen(
            onOpenAarti: () {},
            onOpenJaap: () {},
          ),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      // Find profile/account button in AppTopBar
      final profileButton = find.byIcon(Icons.person_outline);
      expect(profileButton, findsOneWidget);

      // Tap account icon
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Settings screen should be pushed!
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('सेटिंग्स / मेरी प्राथमिकताएँ'), findsOneWidget);
    });
  });
}
