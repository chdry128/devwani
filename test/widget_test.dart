import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devavani/constants/app_strings.dart';
import 'package:devavani/models/mantra.dart';
import 'package:devavani/models/panchang.dart';
import 'package:devavani/providers/audio_provider.dart';
import 'package:devavani/providers/jaap_provider.dart';
import 'package:devavani/services/audio_player_service.dart';
import 'package:devavani/services/storage_service.dart';
import 'package:devavani/utils/date_formatter.dart';
import 'package:devavani/utils/devanagari_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Devanagari Helper Tests', () {
    test('Converts English digits to Devanagari numerals correctly', () {
      expect(DevanagariHelper.format(0), '०');
      expect(DevanagariHelper.format(1), '१');
      expect(DevanagariHelper.format(27), '२७');
      expect(DevanagariHelper.format(108), '१०८');
      expect(DevanagariHelper.format(2024), '२०२४');
    });

    test('Formats Duration into MM:SS format in Devanagari and Latin', () {
      const dur = Duration(minutes: 2, seconds: 15);
      expect(DevanagariHelper.formatDuration(dur, toDevanagari: false), '02:15');
      expect(DevanagariHelper.formatDuration(dur, toDevanagari: true), '०२:१५');
    });
  });

  group('Date Formatter Tests', () {
    test('Formats dates in sacred Hindi devotional format', () {
      final date = DateTime(2024, 3, 20); // Wednesday
      final formatted = DateFormatter.formatFullDate(date, lang: 'hi');
      expect(formatted, contains('बुधवार'));
      expect(formatted, contains('२०'));
      expect(formatted, contains('मार्च'));
      expect(formatted, contains('२०२४'));
    });

    test('Formats dates in Nepali and English', () {
      final date = DateTime(2024, 3, 20);
      final nepali = DateFormatter.formatFullDate(date, lang: 'ne');
      expect(nepali, contains('बुधबार'));

      final english = DateFormatter.formatFullDate(date, lang: 'en');
      expect(english, contains('Wednesday'));
    });
  });

  group('App Strings Localization Tests', () {
    test('Returns correct localized string across languages', () {
      expect(AppStrings.get('appName', lang: 'hi'), 'देववाणी');
      expect(AppStrings.get('appName', lang: 'en'), 'Devavani');
      expect(AppStrings.get('jaapCompleted', lang: 'hi'), 'जाप पूर्ण');
      expect(AppStrings.get('jaapCompleted', lang: 'en'), 'Jaap Complete');
    });
  });

  group('Jaap Provider & Business Logic Tests', () {
    late StorageService storage;
    late AudioPlayerService audioPlayer;
    late JaapProvider jaapProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'devavani_jaap_count': 27,
        'devavani_jaap_daily_total': 108,
        'devavani_jaap_malas': 1,
        'devavani_vibration_enabled': true,
        'devavani_sound_enabled': false,
      });
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      audioPlayer = AudioPlayerService(enablePlatformAudio: false);
      jaapProvider = JaapProvider(storage, audioPlayer);
    });

    test('Initializes state from persistent storage correctly', () {
      expect(jaapProvider.count, 27);
      expect(jaapProvider.malasCompleted, 1);
      expect(jaapProvider.vibrationEnabled, true);
      expect(jaapProvider.soundEnabled, false);
      expect(jaapProvider.selectedMantra.id, 'ram');
    });

    test('Incrementing bead increases count and daily total', () async {
      final initialCount = jaapProvider.count;
      final initialDaily = jaapProvider.dailyTotal;

      await jaapProvider.incrementBead();

      expect(jaapProvider.count, initialCount + 1);
      expect(jaapProvider.dailyTotal, initialDaily + 1);
    });

    test('Completing 108 beads finishes 1 Mala and resets count to 0', () async {
      // Set count to 107
      while (jaapProvider.count < 107) {
        await jaapProvider.incrementBead();
      }
      expect(jaapProvider.count, 107);
      final initialMalas = jaapProvider.malasCompleted;

      // 108th bead completion
      await jaapProvider.incrementBead();

      expect(jaapProvider.count, 0);
      expect(jaapProvider.malasCompleted, initialMalas + 1);
    });

    test('Reset count resets current bead count to 0', () async {
      await jaapProvider.incrementBead();
      expect(jaapProvider.count > 0, true);

      await jaapProvider.resetCount();
      expect(jaapProvider.count, 0);
    });

    test('Switching mantra updates selected mantra', () async {
      final shivaMantra = Mantra.defaultMantras.firstWhere((m) => m.id == 'shiva');
      await jaapProvider.selectMantra(shivaMantra);
      expect(jaapProvider.selectedMantra.id, 'shiva');
      expect(jaapProvider.selectedMantra.name, 'ॐ नमः शिवाय');
    });

    test('Toggling vibration and sound updates state', () async {
      expect(jaapProvider.vibrationEnabled, true);
      await jaapProvider.toggleVibration();
      expect(jaapProvider.vibrationEnabled, false);

      expect(jaapProvider.soundEnabled, false);
      await jaapProvider.toggleSound();
      expect(jaapProvider.soundEnabled, true);
    });
  });

  group('Audio Provider Font Scaling Tests', () {
    late StorageService storage;
    late AudioPlayerService audioPlayer;
    late AudioProvider audioProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'devavani_font_stage': 1});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      audioPlayer = AudioPlayerService(enablePlatformAudio: false);
      audioProvider = AudioProvider(audioPlayer, storage);
    });

    test('Initializes with Large font stage (1)', () {
      expect(audioProvider.fontStage, 1);
      expect(audioProvider.normalFontSize, 23.0);
      expect(audioProvider.activeFontSize, 26.0);
    });

    test('Font magnification increases and decreases within valid range', () async {
      await audioProvider.increaseFontSize();
      expect(audioProvider.fontStage, 2);
      expect(audioProvider.normalFontSize, 27.0);

      // Cannot exceed max stage 2
      await audioProvider.increaseFontSize();
      expect(audioProvider.fontStage, 2);

      await audioProvider.decreaseFontSize();
      expect(audioProvider.fontStage, 1);

      await audioProvider.decreaseFontSize();
      expect(audioProvider.fontStage, 0);
      expect(audioProvider.normalFontSize, 20.0);

      // Cannot decrease below stage 0
      await audioProvider.decreaseFontSize();
      expect(audioProvider.fontStage, 0);
    });
  });

  group('Panchang Model Tests', () {
    test('Default panchang provides tithi, timings, and 3 dos & donts', () {
      final panchang = PanchangData.defaultToday;
      expect(panchang.tithi, isNotEmpty);
      expect(panchang.sunrise, isNotEmpty);
      expect(panchang.sunset, isNotEmpty);
      expect(panchang.dos.length, 3);
      expect(panchang.donts.length, 3);
    });
  });
}
