import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:devavani/providers/audio_provider.dart';
import 'package:devavani/providers/jaap_provider.dart';
import 'package:devavani/providers/panchang_provider.dart';
import 'package:devavani/providers/settings_provider.dart';
import 'package:devavani/screens/home_screen.dart';
import 'package:devavani/screens/jaap_screen.dart';
import 'package:devavani/screens/aarti_screen.dart';
import 'package:devavani/screens/panchang_screen.dart';
import 'package:devavani/screens/more_screen.dart';
import 'package:devavani/services/audio_player_service.dart';
import 'package:devavani/services/notification_service.dart';
import 'package:devavani/services/panchang_service.dart';
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
    child: MaterialApp(home: child),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('HomeScreen renders greeting and 3 main action cards', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(
      createTestApp(
        HomeScreen(onOpenAarti: () {}, onOpenJaap: () {}),
        storage: storage,
        audio: audio,
        notifications: notifications,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('नमस्ते'), findsOneWidget);
    expect(find.text('आज की आरती / चालीसा'), findsOneWidget);
    expect(find.text('जाप शुरू करें'), findsOneWidget);
    expect(find.text('आज का पंचांग'), findsOneWidget);
  });

  testWidgets(
    'JaapScreen renders dial, mantra, tap prompt, and increments on tap',
    (tester) async {
      configureViewport(tester);
      await storage.saveJaapCount(27);
      await tester.pumpWidget(
        createTestApp(
          const JaapScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('श्री राम जय राम'), findsOneWidget);
      expect(find.text('स्क्रीन पर कहीं भी स्पर्श करें'), findsOneWidget);
      expect(find.text('जाप पूर्ण'), findsOneWidget);
      expect(find.text('पुनः सेट करें (नया जाप)'), findsOneWidget);

      // Tap anywhere on the tap area to increment
      await tester.tap(find.byKey(const Key('jaap_tap_zone')));
      await tester.pumpAndSettle();

      // Verify counter incremented from 27 to 28
      expect(find.text('२८'), findsOneWidget);
    },
  );

  testWidgets('PanchangScreen renders Tithi, Sunrise, Sunset, and Dos/Donts', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(
      createTestApp(
        const PanchangScreen(),
        storage: storage,
        audio: audio,
        notifications: notifications,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('आज का पंचांग'), findsAtLeast(1));
    expect(
      find.text(PanchangService.getToday(lang: 'hi').tithi),
      findsOneWidget,
    );
    expect(find.text('सूर्योदय'), findsOneWidget);
    expect(find.text('सूर्यास्त'), findsOneWidget);
    expect(find.text('आज क्या करें'), findsOneWidget);
    expect(find.text('आज क्या न करें'), findsOneWidget);
  });

  testWidgets(
    'AartiScreen renders Hanuman Chalisa, lyrics, and media controls',
    (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(
        createTestApp(
          const AartiScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('श्री हनुमान चालीसा'), findsOneWidget);
      expect(find.text('पवित्र दोहा एवं चौपाई'), findsOneWidget);
      expect(find.text('आरती दोहराएं (Loop)'), findsOneWidget);
      expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.forward_10_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'MoreScreen renders God of the Day, Ganesha Mantra, and Pushpa Arpan',
    (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(
        createTestApp(
          const MoreScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('आज के देवता: श्री गणेश जी'), findsOneWidget);
      expect(find.text('ॐ गं गणपतये नमः'), findsOneWidget);
      expect(find.text('डिजिटल पुष्प अर्पण'), findsOneWidget);
      expect(find.text('अर्पित करें'), findsOneWidget);

      // Ensure flower button is scrolled into view and tap
      await tester.ensureVisible(find.text('अर्पित करें'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('अर्पित करें'));
      await tester.pumpAndSettle();

      expect(find.textContaining('1 पुष्प अर्पित'), findsOneWidget);
    },
  );
}
