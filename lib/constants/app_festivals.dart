// ══════════════════════════════════════════════════════════════════════════════
// APP FESTIVALS — Major Hindu festival registry
// ══════════════════════════════════════════════════════════════════════════════
//
// These festivals drive the highest-priority content selection in the app.
// When a festival is active today, its related God becomes the "God of the Day"
// and the related Aarti becomes "Aaj ki Aarti".
//
// NOTE: Hindu festivals follow the lunar calendar and dates shift every year.
// The approximate dates below are for offline fallback only.
// For production accuracy, update these dates annually or use a Panchang API.

import '../models/festival_model.dart';
import '../models/god_model.dart';
import 'package:tithi_engine/data/all.dart';
import 'package:tithi_engine/tithi_engine.dart';

/// All major Hindu festivals recognized by the app.
class AppFestivals {
  AppFestivals._();

  static final Panchang _panchang = Panchang([registerAllCities]);
  static final City _festivalCity = City.tryOf('Kathmandu') ?? defaultCity;

  /// Maps the app's display metadata to the engine's exact lunar festivals.
  /// Janmashtami uses the Smarta observance (nishita/midnight), which is the
  /// traditional general-purpose choice for this app.
  static const Map<String, List<String>> _engineFestivalIds = {
    'mahashivratri': ['maha_shivaratri'],
    'ram_navami': ['ram_navami'],
    'ganesh_chaturthi': ['ganesh_chaturthi'],
    'navratri': ['sharad_navratri', 'durga_ashtami', 'maha_navami'],
    'janmashtami': ['janmashtami_smarta', 'janmashtami_iskcon'],
    'diwali': ['diwali'],
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Individual Festival definitions
  // ─────────────────────────────────────────────────────────────────────────

  static const FestivalModel hanumanJayanti = FestivalModel(
    id: 'hanuman_jayanti',
    name: LocalizedText(
      hi: 'हनुमान जयंती',
      ne: 'हनुमान जयन्ती',
      en: 'Hanuman Jayanti',
    ),
    description: LocalizedText(
      hi: 'श्री हनुमान जी के जन्मोत्सव का पावन दिन',
      ne: 'श्री हनुमान जीको जन्मोत्सवको पावन दिन',
      en: 'Sacred day celebrating the birth of Lord Hanuman',
    ),
    relatedGodId: 'hanuman',
    approximateMonth: 4, // April (Chaitra Purnima)
    approximateDay: 15,
    flexDays: 1,
  );

  static const FestivalModel mahashivratri = FestivalModel(
    id: 'mahashivratri',
    name: LocalizedText(
      hi: 'महाशिवरात्रि',
      ne: 'महाशिवरात्रि',
      en: 'Mahashivratri',
    ),
    description: LocalizedText(
      hi: 'भगवान शिव की रात्रि पूजा का महापर्व',
      ne: 'भगवान शिवको रात्रि पूजाको महापर्व',
      en: 'The great night festival of Lord Shiva',
    ),
    relatedGodId: 'shiva',
    approximateMonth: 3, // Feb-March (Phalguna)
    approximateDay: 1,
    flexDays: 1,
  );

  static const FestivalModel ganeshChaturthi = FestivalModel(
    id: 'ganesh_chaturthi',
    name: LocalizedText(
      hi: 'गणेश चतुर्थी',
      ne: 'गणेश चतुर्थी',
      en: 'Ganesh Chaturthi',
    ),
    description: LocalizedText(
      hi: 'गणपति बप्पा के आगमन का उत्सव',
      ne: 'गणपति बप्पाको आगमनको उत्सव',
      en: 'Festival celebrating the arrival of Lord Ganesha',
    ),
    relatedGodId: 'ganesha',
    approximateMonth: 9, // August-September (Bhadrapada)
    approximateDay: 7,
    flexDays: 10, // Multi-day festival
  );

  static const FestivalModel navratri = FestivalModel(
    id: 'navratri',
    name: LocalizedText(hi: 'नवरात्रि', ne: 'नवरात्रि', en: 'Navratri'),
    description: LocalizedText(
      hi: 'माँ दुर्गा की नौ रातों का पावन पर्व',
      ne: 'माँ दुर्गाको नौ रातको पावन पर्व',
      en: 'The sacred nine nights of Goddess Durga',
    ),
    relatedGodId: 'durga',
    approximateMonth: 10, // Sept-October (Sharad)
    approximateDay: 3,
    flexDays: 9, // 9 days
  );

  static const FestivalModel janmashtami = FestivalModel(
    id: 'janmashtami',
    name: LocalizedText(hi: 'जन्माष्टमी', ne: 'जन्माष्टमी', en: 'Janmashtami'),
    description: LocalizedText(
      hi: 'भगवान श्री कृष्ण के जन्मोत्सव का पावन दिन',
      ne: 'भगवान श्री कृष्णको जन्मोत्सवको पावन दिन',
      en: 'Sacred day celebrating the birth of Lord Krishna',
    ),
    relatedGodId: 'krishna',
    approximateMonth: 8, // August (Bhadrapada)
    approximateDay: 26,
    flexDays: 1,
  );

  static const FestivalModel ramNavami = FestivalModel(
    id: 'ram_navami',
    name: LocalizedText(hi: 'रामनवमी', ne: 'रामनवमी', en: 'Ram Navami'),
    description: LocalizedText(
      hi: 'प्रभु श्री राम के जन्मोत्सव का पावन दिन',
      ne: 'प्रभु श्री रामको जन्मोत्सवको पावन दिन',
      en: 'Sacred day celebrating the birth of Lord Ram',
    ),
    relatedGodId: 'ram',
    approximateMonth: 4, // March-April (Chaitra)
    approximateDay: 2,
    flexDays: 1,
  );

  static const FestivalModel diwali = FestivalModel(
    id: 'diwali',
    name: LocalizedText(hi: 'दीपावली', ne: 'दीपावली', en: 'Diwali'),
    description: LocalizedText(
      hi: 'दीपों का त्योहार — श्री राम के अयोध्या आगमन का उत्सव',
      ne: 'दीपहरूको त्यौहार — श्री रामको अयोध्या आगमनको उत्सव',
      en: 'Festival of lights — celebrating Lord Ram\'s return to Ayodhya',
    ),
    relatedGodId: 'ram',
    approximateMonth: 11, // October-November (Kartik)
    approximateDay: 1,
    flexDays: 2,
  );

  static const FestivalModel makarSankranti = FestivalModel(
    id: 'makar_sankranti',
    name: LocalizedText(
      hi: 'मकर संक्रांति',
      ne: 'मकर सङ्क्रान्ति',
      en: 'Makar Sankranti',
    ),
    description: LocalizedText(
      hi: 'सूर्य देव का मकर राशि में प्रवेश — स्नान और दान का पर्व',
      ne: 'सूर्य देवको मकर राशिमा प्रवेश — स्नान र दानको पर्व',
      en: 'Sun enters Capricorn — festival of holy bath and charity',
    ),
    relatedGodId: 'ram', // Sun deity → closest is Ram (Surya Vanshi)
    approximateMonth: 1, // January 14-15
    approximateDay: 14,
    flexDays: 1,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Complete list of all festivals
  // ─────────────────────────────────────────────────────────────────────────

  /// Master list of all festivals. Add new festivals here.
  static const List<FestivalModel> allFestivals = [
    hanumanJayanti,
    mahashivratri,
    ganeshChaturthi,
    navratri,
    janmashtami,
    ramNavami,
    diwali,
    makarSankranti,
  ];

  /// Returns the first festival active on the given [date], or null if none.
  ///
  /// Checks all festivals and returns the first match.
  /// For production, replace this with a year-specific date lookup.
  static FestivalModel? getActiveFestival([DateTime? date]) {
    final checkDate = date ?? DateTime.now();

    // Hindu festival dates move with the lunar calendar. Resolve them from
    // the astronomy engine instead of the approximate metadata dates below.
    for (final festival in allFestivals) {
      final engineIds = _engineFestivalIds[festival.id];
      if (engineIds == null) continue;

      for (final engineFestival in festivals) {
        if (!engineIds.contains(engineFestival.id)) continue;
        final occurrence = _panchang.dateFor(
          engineFestival,
          checkDate.year,
          _festivalCity,
        );
        if (_sameCalendarDate(occurrence?.date, checkDate)) return festival;
      }
    }

    // Keep the offline metadata only for festivals that are not represented by
    // the current engine release, such as Hanuman Jayanti.
    for (final festival in allFestivals) {
      if (_engineFestivalIds.containsKey(festival.id)) continue;
      if (festival.isOnDate(checkDate)) {
        return festival;
      }
    }
    return null;
  }

  static bool _sameCalendarDate(DateTime? left, DateTime right) {
    return left != null &&
        left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  /// Returns all festivals related to a specific God.
  static List<FestivalModel> getFestivalsForGod(String godId) {
    return allFestivals.where((f) => f.relatedGodId == godId).toList();
  }

  /// Quick lookup by ID.
  static FestivalModel? getById(String id) {
    for (final festival in allFestivals) {
      if (festival.id == id) return festival;
    }
    return null;
  }
}
