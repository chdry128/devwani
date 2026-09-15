import 'package:flutter_test/flutter_test.dart';
import 'package:devavani/constants/app_gods.dart';
import 'package:devavani/constants/app_aartis.dart';
import 'package:devavani/constants/app_festivals.dart';
import 'package:devavani/models/daily_panchang.dart';
import 'package:devavani/models/jaap_model.dart';
import 'package:devavani/models/user_preference.dart';
import 'package:devavani/services/today_service.dart';
import 'package:devavani/models/deity.dart';
import 'package:devavani/models/aarti.dart';
import 'package:devavani/models/mantra.dart';
import 'package:devavani/models/panchang.dart';
import 'package:tithi_engine/data/all.dart';
import 'package:tithi_engine/tithi_engine.dart';

void main() {
  group('Devavani Data Layer Tests', () {
    test(
      'AppGods contains 6 canonical deities with complete tri-language data',
      () {
        expect(AppGods.allGods.length, 6);

        for (final god in AppGods.allGods) {
          expect(god.id.isNotEmpty, true);
          expect(god.name.hi.isNotEmpty, true);
          expect(god.name.ne.isNotEmpty, true);
          expect(god.name.en.isNotEmpty, true);

          expect(god.nameHindi, god.name.hi);
          expect(god.nameNepali, god.name.ne);
          expect(god.nameEnglish, god.name.en);

          expect(god.shortDescription.hi.isNotEmpty, true);
          expect(god.mantra.hi.isNotEmpty, true);
          expect(god.mantraMeaning.hi.isNotEmpty, true);
          expect(god.imagePath.isNotEmpty, true);
        }
      },
    );

    test('Weekday to God mapping covers all 7 days of the week', () {
      expect(AppGods.weekdayGodMap.length, 7);
      expect(AppGods.weekdayGodMap[DateTime.monday], 'shiva');
      expect(AppGods.weekdayGodMap[DateTime.tuesday], 'hanuman');
      expect(AppGods.weekdayGodMap[DateTime.wednesday], 'ganesha');
      expect(AppGods.weekdayGodMap[DateTime.thursday], 'ram');
      expect(AppGods.weekdayGodMap[DateTime.friday], 'durga');
      expect(AppGods.weekdayGodMap[DateTime.saturday], 'hanuman');
      expect(AppGods.weekdayGodMap[DateTime.sunday], 'ram');
    });

    test(
      'AppAartis contains all 6 deity aartis with proper day/festival mapping',
      () {
        expect(AppAartis.allAartis.length, 6);

        final hanumanAarti = AppAartis.getDefaultForGod('hanuman');
        expect(hanumanAarti.id, 'hanuman_chalisa');
        expect(hanumanAarti.relatedGodId, 'hanuman');
        expect(hanumanAarti.verses.isNotEmpty, true);
        expect(hanumanAarti.lyrics.length, hanumanAarti.verses.length);

        final shivAarti = AppAartis.getDefaultForGod('shiva');
        expect(shivAarti.id, 'shiv_aarti');

        final ganeshAarti = AppAartis.getDefaultForGod('ganesha');
        expect(ganeshAarti.id, 'ganesh_aarti');
      },
    );

    test('Every Aarti uses the image registered for its related God', () {
      for (final aarti in AppAartis.allAartis) {
        final god = AppGods.getById(aarti.relatedGodId);

        expect(god, isNotNull);
        expect(aarti.imagePath, god!.imagePath);
      }
    });

    test('TodayService priority 1: Festival takes highest precedence', () {
      // Create a test festival
      final festival = AppFestivals.hanumanJayanti;
      final festivalDate = DateTime(
        2026,
        festival.approximateMonth,
        festival.approximateDay,
      );

      final result = TodayService.getToday(date: festivalDate);
      expect(result.reason, SelectionReason.festival);
      expect(result.festival, isNotNull);
      expect(result.god.id, festival.relatedGodId);
    });

    test('Exact Janmashtami date selects Krishna and Krishna image', () {
      final panchang = Panchang([registerAllCities]);
      final janmashtami = festivals.firstWhere(
        (festival) => festival.id == 'janmashtami_smarta',
      );
      final city = City.tryOf('Kathmandu') ?? defaultCity;
      final festivalDate = panchang.dateFor(janmashtami, 2026, city)!.date;

      final result = TodayService.getToday(date: festivalDate);

      expect(result.reason, SelectionReason.festival);
      expect(result.festival?.id, 'janmashtami');
      expect(result.god.id, 'krishna');
      expect(result.god.imagePath, 'assets/images/krishna_ji.jpg');
    });

    test('TodayService priority 2: Weekday mapping when no festival', () {
      // Pick a non-festival date (e.g., Nov 10, 2026 is Tuesday)
      final tuesdayDate = DateTime(2026, 11, 10);
      expect(tuesdayDate.weekday, DateTime.tuesday);

      final result = TodayService.getToday(date: tuesdayDate);
      expect(result.reason, SelectionReason.weekday);
      expect(result.god.id, 'hanuman');
    });

    test('TodayService priority 3 & 4: User preference and Fallback', () {
      final god = TodayService.getTodaysGod();
      expect(god, isNotNull);

      final aarti = TodayService.getTodaysAarti();
      expect(aarti, isNotNull);
    });

    test('JaapSession and JaapModel calculations', () {
      final session = JaapSession(
        selectedMantraId: 'om_namah_shivaya',
        currentCount: 54,
        target: 108,
        todayTotal: 108,
      );

      expect(session.count, 54);
      expect(session.progress, 0.5);
      expect(session.isMalaComplete, false);
      expect(session.selectedMantra, 'om_namah_shivaya');

      final completed = session.copyWith(currentCount: 108);
      expect(completed.isMalaComplete, true);
      expect(completed.progress, 1.0);
    });

    test('UserPreference handles languages, font stages, and aliases', () {
      const pref = UserPreference(
        preferredGodIds: ['shiva', 'hanuman'],
        language: AppLanguage.hi,
        fontStage: FontStage.large,
      );

      expect(pref.primaryGodId, 'shiva');
      expect(pref.secondaryGodId, 'hanuman');
      expect(pref.preferredGods, ['shiva', 'hanuman']);
      expect(pref.brahmaMuhurtaReminder, true);
      expect(pref.fontSize, FontStage.large);
      expect(pref.langCode, 'hi');
      expect(pref.fontStage.scaleFactor, 1.25);
    });

    test('DailyPanchang provides proper data fields', () {
      final panchang = DailyPanchang.sampleToday;
      expect(panchang.tithi, isNotEmpty);
      expect(panchang.sunrise, isNotEmpty);
      expect(panchang.sunset, isNotEmpty);
      expect(panchang.doList.length, greaterThan(0));
      expect(panchang.avoidList.length, greaterThan(0));
      expect(panchang.dos.length, panchang.doList.length);
      expect(panchang.donts.length, panchang.avoidList.length);
    });

    test(
      'Backwards compatibility wrappers compile and provide legacy interface',
      () {
        // DeityOfDay legacy wrapper
        expect(DeityOfDay.ganesha.name, isNotEmpty);
        final todayDeity = DeityOfDay.fromToday(lang: 'hi');
        expect(todayDeity.name, isNotEmpty);

        // Aarti legacy wrapper
        expect(Aarti.defaultHanumanChalisa.title, isNotEmpty);
        expect(Aarti.defaultHanumanChalisa.verses.isNotEmpty, true);

        // Mantra legacy wrapper
        expect(Mantra.defaultMantras.length, greaterThan(0));

        // PanchangData legacy wrapper
        expect(PanchangData.defaultToday.tithi, isNotEmpty);
      },
    );
  });
}
