// ══════════════════════════════════════════════════════════════════════════════
// AAJ KI AARTI TEST SUITE — Verifies 4-tier priority, asset pairing, and UI
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:devavani/constants/app_festivals.dart';
import 'package:devavani/models/aarti_item.dart';
import 'package:devavani/providers/audio_provider.dart';
import 'package:devavani/providers/settings_provider.dart';
import 'package:devavani/screens/aarti_screen.dart';
import 'package:devavani/services/aaj_ki_aarti_service.dart';
import 'package:devavani/services/audio_player_service.dart';
import 'package:devavani/services/notification_service.dart';
import 'package:devavani/services/storage_service.dart';
import 'package:devavani/widgets/aarti_lyrics_scroller.dart';

/// In-memory asset bundle for testing lyrics loading and fallback resilience
class TestAssetBundle extends CachingAssetBundle {
  final Map<String, String> assets;

  TestAssetBundle(this.assets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (assets.containsKey(key)) {
      return assets[key]!;
    }
    throw FlutterError('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final string = assets[key];
    if (string == null) throw FlutterError('Asset not found: $key');
    final bytes = Uint8List.fromList(string.codeUnits);
    return ByteData.view(bytes.buffer);
  }
}

Widget createAartiTestApp({
  required Widget child,
  required StorageService storage,
  required AudioPlayerService audio,
  required NotificationService notifications,
}) {
  return MultiProvider(
    providers: [
      Provider<StorageService>.value(value: storage),
      Provider<AudioPlayerService>.value(value: audio),
      Provider<NotificationService>.value(value: notifications),
      ChangeNotifierProvider<AudioProvider>(
        create: (_) => AudioProvider(audio, storage),
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

  group('Aaj Ki Aarti Service & Priority Selection Tests', () {
    test('Catalog contains all 6 deity aartis with valid audio and .txt pairs', () {
      final aartis = AajKiAartiService.allAartis;
      expect(aartis.length, 6);

      for (final aarti in aartis) {
        expect(aarti.id, isNotEmpty);
        expect(aarti.audioPath, startsWith('assets/audio/aarti/'));
        expect(aarti.audioPath, endsWith('.mp3'));
        expect(aarti.lyricsPath, startsWith('assets/audio/aarti/'));
        expect(aarti.lyricsPath, endsWith('.txt'));
        expect(aarti.title.hi, isNotEmpty);
        expect(aarti.title.ne, isNotEmpty);
        expect(aarti.title.en, isNotEmpty);
        expect(aarti.relatedGodId, isNotEmpty);
      }
    });

    test('Priority 1: Festival today takes highest precedence', () {
      final festival = AppFestivals.mahashivratri;
      final festivalDate = DateTime(2026, festival.approximateMonth, festival.approximateDay);
      final result = AajKiAartiService.selectTodaysAarti(
        preferredGodIds: ['hanuman'], // User preferred Hanuman, but festival overrides!
        date: festivalDate,
      );

      expect(result.selectionReason, AartiSelectionReason.festival);
      expect(result.relatedGodId, 'shiva');
      expect(result.id, 'om_jai_shiv_omkara');
      expect(result.selectionBadge.hi, contains('महाशिवरात्रि'));
    });

    test('Priority 2: Day of the week when no festival is active', () {
      // Monday = Shiva (May 13, 2024 was Monday, no major festival)
      final monday = DateTime(2024, 5, 13);
      final monAarti = AajKiAartiService.selectTodaysAarti(date: monday);
      expect(monAarti.selectionReason, AartiSelectionReason.weekday);
      expect(monAarti.relatedGodId, 'shiva');
      expect(monAarti.id, 'om_jai_shiv_omkara');

      // Tuesday = Hanuman (May 14, 2024 was Tuesday)
      final tuesday = DateTime(2024, 5, 14);
      final tueAarti = AajKiAartiService.selectTodaysAarti(date: tuesday);
      expect(tueAarti.selectionReason, AartiSelectionReason.weekday);
      expect(tueAarti.relatedGodId, 'hanuman');
      expect(tueAarti.id, 'hanuman_chalisa');

      // Wednesday = Ganesh (May 15, 2024 was Wednesday)
      final wednesday = DateTime(2024, 5, 15);
      final wedAarti = AajKiAartiService.selectTodaysAarti(date: wednesday);
      expect(wedAarti.selectionReason, AartiSelectionReason.weekday);
      expect(wedAarti.relatedGodId, 'ganesha');
      expect(wedAarti.id, 'jai_ganesh_deva');

      // Thursday = Vishnu / Ram (May 16, 2024 was Thursday)
      final thursday = DateTime(2024, 5, 16);
      final thuAarti = AajKiAartiService.selectTodaysAarti(date: thursday);
      expect(thuAarti.selectionReason, AartiSelectionReason.weekday);
      expect(thuAarti.id, 'om_jai_jagdish_hare');

      // Friday = Durga / Vishnu (May 17, 2024 was Friday)
      final friday = DateTime(2024, 5, 17);
      final friAarti = AajKiAartiService.selectTodaysAarti(date: friday);
      expect(friAarti.selectionReason, AartiSelectionReason.weekday);
      expect(friAarti.id, 'om_jai_jagdish_hare');

      // Saturday = Hanuman (May 18, 2024 was Saturday)
      final saturday = DateTime(2024, 5, 18);
      final satAarti = AajKiAartiService.selectTodaysAarti(date: saturday);
      expect(satAarti.selectionReason, AartiSelectionReason.weekday);
      expect(satAarti.relatedGodId, 'hanuman');

      // Sunday = Krishna (May 19, 2024 was Sunday)
      final sunday = DateTime(2024, 5, 19);
      final sunAarti = AajKiAartiService.selectTodaysAarti(date: sunday);
      expect(sunAarti.selectionReason, AartiSelectionReason.weekday);
      expect(sunAarti.relatedGodId, 'krishna');
    });

    test('Priority 3: User preference when specified', () {
      final userPrefShiva = AajKiAartiService.getDefaultForGod('shiva');
      expect(userPrefShiva.id, 'om_jai_shiv_omkara');

      final userPrefGanesh = AajKiAartiService.getDefaultForGod('ganesha');
      expect(userPrefGanesh.id, 'jai_ganesh_deva');

      final userPrefKrishna = AajKiAartiService.getDefaultForGod('krishna');
      expect(userPrefKrishna.id, 'aarti_kunj_bihari_ki');
    });

    test('Priority 4: Fallback defaults gracefully to Hanuman Chalisa', () {
      final fallback = AajKiAartiService.getDefaultForGod('unknown_id');
      expect(fallback.id, 'hanuman_chalisa');
    });

    test('Audio file name God detector identifies deities from keywords', () {
      expect(AajKiAartiService.detectGodFromFileName('hanuman_chalisa.mp3'), 'hanuman');
      expect(AajKiAartiService.detectGodFromFileName('HanumanJiKIAarti (1).mp3'), 'hanuman');
      expect(AajKiAartiService.detectGodFromFileName('OmJaiShivOmkaraShivAarti1.mp3'), 'shiva');
      expect(AajKiAartiService.detectGodFromFileName('Jai-Ganesh-Jai-Ganesh-Deva-Ganes.mp3'), 'ganesha');
      expect(AajKiAartiService.detectGodFromFileName('Aarti-Kunj-Bihari-Ki.mp3'), 'krishna');
      expect(AajKiAartiService.detectGodFromFileName('OM-JAI-JAGDISH-HARE.mp3'), 'ram');
    });
  });

  group('Offline Lyrics Loader & Cache Tests', () {
    setUp(() {
      AajKiAartiService.clearCache();
    });

    test('Loads and caches lyrics successfully from asset bundle', () async {
      final testBundle = TestAssetBundle({
        'assets/audio/aarti/sample.txt': 'जय हनुमान ज्ञान गुन सागर\n\nजय कपीस तिहुँ लोक उजागर',
      });

      final lyrics = await AajKiAartiService.loadLyrics(
        'assets/audio/aarti/sample.txt',
        bundle: testBundle,
      );

      expect(lyrics, contains('जय हनुमान ज्ञान गुन सागर'));
      expect(lyrics, contains('जय कपीस तिहुँ लोक उजागर'));

      // Subsequent call retrieves from memory cache
      final cached = await AajKiAartiService.loadLyrics('assets/audio/aarti/sample.txt');
      expect(cached, lyrics);
    });

    test('Gracefully returns friendly message when lyrics file is missing', () async {
      final testBundle = TestAssetBundle({});

      final lyrics = await AajKiAartiService.loadLyrics(
        'assets/audio/aarti/missing_file.txt',
        bundle: testBundle,
      );

      expect(lyrics, contains('आरती के पावन बोल शीघ्र ही उपलब्ध होंगे'));
      expect(lyrics, contains('हरि ॐ तत्सत्'));
    });
  });

  group('AartiLyricsScroller Widget Tests', () {
    testWidgets('Renders lyrics, auto-scroll status, and font zoom buttons', (tester) async {
      int fontStage = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AartiLyricsScroller(
              lyrics: 'श्रीगुरु चरन सरोज रज\nनिज मनु मुकुरु सुधारि।',
              isLoading: false,
              isPlaying: true,
              progress: 0.5,
              fontSize: 23.0,
              onIncreaseFont: () => fontStage++,
              onDecreaseFont: () => fontStage--,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and lyrics
      expect(find.text('पवित्र आरती के बोल'), findsOneWidget);
      expect(find.text('पवित्र दोहा एवं चौपाई'), findsOneWidget);
      expect(find.text('धीमा स्वतः स्क्रॉल सक्रिय'), findsOneWidget);
      expect(find.textContaining('श्रीगुरु चरन सरोज रज'), findsOneWidget);

      // Tap font increase button
      await tester.tap(find.text('अ A+'));
      await tester.pump();
      expect(fontStage, 2);

      // Tap font decrease button
      await tester.tap(find.text('अ A-'));
      await tester.pump();
      expect(fontStage, 1);
    });

    testWidgets('Shows loading indicator when lyrics are loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AartiLyricsScroller(
              lyrics: null,
              isLoading: true,
              isPlaying: false,
              progress: 0.0,
              fontSize: 23.0,
              onIncreaseFont: () {},
              onDecreaseFont: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('आरती के पावन बोल लोड हो रहे हैं...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AartiScreen UI & Audio Controls Tests', () {
    late StorageService storage;
    late AudioPlayerService audio;
    late NotificationService notifications;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'devavani_font_stage': 1});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      audio = AudioPlayerService(enablePlatformAudio: false);
      notifications = NotificationService();
    });

    testWidgets('Renders complete Aarti Screen with big controls and selection sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createAartiTestApp(
          child: const AartiScreen(),
          storage: storage,
          audio: audio,
          notifications: notifications,
        ),
      );
      await tester.pumpAndSettle();

      // Check title and deity card
      expect(find.text('श्री हनुमान चालीसा'), findsOneWidget);
      expect(find.text('संकट मोचन कृपा • महाबलशाली'), findsOneWidget);

      // Check big media controls
      expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.forward_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.text('आरती दोहराएं (Loop)'), findsOneWidget);

      // Open Aarti selection bottom sheet
      await tester.tap(find.byIcon(Icons.queue_music_rounded));
      await tester.pumpAndSettle();

      expect(find.text('सभी पवित्र आरतियां'), findsOneWidget);
      expect(find.text('जय गणेश जय गणेश देवा'), findsOneWidget);
      expect(find.text('ॐ जय शिव ओंकारा'), findsOneWidget);
      expect(find.text('आरती कुंजबिहारी की'), findsOneWidget);

      // Select Lord Shiva Aarti from the sheet
      await tester.tap(find.text('ॐ जय शिव ओंकारा'));
      await tester.pumpAndSettle();

      // Screen now displays Lord Shiva Aarti!
      expect(find.text('ॐ जय शिव ओंकारा'), findsOneWidget);
      expect(find.text('महादेव शिव शंकर आरती'), findsOneWidget);
    });
  });
}
