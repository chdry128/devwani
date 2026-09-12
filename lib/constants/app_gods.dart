// ══════════════════════════════════════════════════════════════════════════════
// APP GODS — Complete God registry and weekday mapping
// ══════════════════════════════════════════════════════════════════════════════
//
// Central source of truth for all Gods in the app.
// To add a new God, simply add a new [GodModel] to [allGods] and
// a corresponding entry in [AssetPaths].

import '../models/god_model.dart';
import '../models/mantra_model.dart';
import 'asset_paths.dart';

/// All Gods available in the app.
class AppGods {
  AppGods._();

  // ─────────────────────────────────────────────────────────────────────────
  // Individual God definitions
  // ─────────────────────────────────────────────────────────────────────────

  static const GodModel hanuman = GodModel(
    id: 'hanuman',
    name: LocalizedText(
      hi: 'श्री हनुमान जी',
      ne: 'श्री हनुमान जी',
      en: 'Lord Hanuman',
    ),
    imagePath: AssetPaths.hanumanJi,
    shortDescription: LocalizedText(
      hi: 'संकटमोचन हनुमान जी भक्ति, शक्ति और साहस के प्रतीक हैं। मंगलवार को इनकी पूजा विशेष फलदायी होती है।',
      ne: 'सङ्कटमोचन हनुमान जी भक्ति, शक्ति र साहसका प्रतीक हुनुहुन्छ। मङ्गलवार इनको पूजा विशेष फलदायी हुन्छ।',
      en: 'Lord Hanuman symbolizes devotion, strength, and courage. Worshipping him on Tuesday is especially fruitful.',
    ),
    mantra: LocalizedText(
      hi: 'ॐ हं हनुमते नमः',
      ne: 'ॐ हं हनुमते नमः',
      en: 'Om Ham Hanumate Namah',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: हे पवनपुत्र हनुमान, हमें शक्ति और भक्ति प्रदान करें।',
      ne: 'भावार्थ: हे पवनपुत्र हनुमान, हामीलाई शक्ति र भक्ति प्रदान गर्नुहोस्।',
      en: 'Meaning: O Son of Wind, grant us strength and devotion.',
    ),
    themeColorHex: 0xFFE67E22, // Saffron / Orange
  );

  static const GodModel shiva = GodModel(
    id: 'shiva',
    name: LocalizedText(
      hi: 'भगवान शिव',
      ne: 'भगवान शिव',
      en: 'Lord Shiva',
    ),
    imagePath: AssetPaths.shivaJi,
    shortDescription: LocalizedText(
      hi: 'भगवान शिव देवों के देव महादेव हैं। सोमवार को शिव जी की पूजा से मनोकामना पूर्ण होती है।',
      ne: 'भगवान शिव देवताहरूका देव महादेव हुनुहुन्छ। सोमवार शिवजीको पूजाले मनोकामना पूर्ण हुन्छ।',
      en: 'Lord Shiva is the supreme deity, Mahadeva. Worshipping him on Monday fulfills wishes.',
    ),
    mantra: LocalizedText(
      hi: 'ॐ नमः शिवाय',
      ne: 'ॐ नमः शिवाय',
      en: 'Om Namah Shivaya',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: भगवान भोलेनाथ का पंचाक्षरी महामंत्र — कल्याण और मोक्ष प्रदान करे।',
      ne: 'भावार्थ: भगवान भोलेनाथको पञ्चाक्षरी महामन्त्र — कल्याण र मोक्ष प्रदान गर्नुहोस्।',
      en: 'Meaning: The five-syllable Mahamantra of Lord Shiva — bestows welfare and liberation.',
    ),
    themeColorHex: 0xFF5C6BC0, // Indigo / Blue (Shiva's blue hue)
  );

  static const GodModel ganesha = GodModel(
    id: 'ganesha',
    name: LocalizedText(
      hi: 'श्री गणेश जी',
      ne: 'श्री गणेश जी',
      en: 'Lord Ganesha',
    ),
    imagePath: AssetPaths.ganeshaJi,
    shortDescription: LocalizedText(
      hi: 'भगवान श्री गणेश विघ्नहर्ता और प्रथम पूज्य देव हैं। बुधवार को गणेश जी का स्मरण करने से बुद्धि और सुख प्राप्त होता है।',
      ne: 'भगवान श्री गणेश विघ्नहर्ता र प्रथम पूज्य देव हुनुहुन्छ। बुधवार गणेश जीको स्मरणले बुद्धि र सुख प्राप्त हुन्छ।',
      en: 'Lord Ganesha is the remover of obstacles and the first-worshipped deity. Worshipping him on Wednesday brings wisdom and happiness.',
    ),
    mantra: LocalizedText(
      hi: 'ॐ गं गणपतये नमः',
      ne: 'ॐ गं गणपतये नमः',
      en: 'Om Gam Ganapataye Namah',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: हे विघ्नहर्ता, हमारे सभी कष्ट दूर करें।',
      ne: 'भावार्थ: हे विघ्नहर्ता, हाम्रा सम्पूर्ण कष्टहरू निवारण गर्नुहोस्।',
      en: 'Meaning: O Remover of Obstacles, remove all our difficulties.',
    ),
    themeColorHex: 0xFFEF5350, // Vermilion / Red (Sindoor)
  );

  static const GodModel durga = GodModel(
    id: 'durga',
    name: LocalizedText(
      hi: 'माँ दुर्गा',
      ne: 'माँ दुर्गा',
      en: 'Goddess Durga',
    ),
    imagePath: AssetPaths.durgaMaa,
    shortDescription: LocalizedText(
      hi: 'माँ दुर्गा शक्ति और संरक्षण की देवी हैं। शुक्रवार और नवरात्रि में इनकी पूजा विशेष रूप से की जाती है।',
      ne: 'माँ दुर्गा शक्ति र संरक्षणकी देवी हुनुहुन्छ। शुक्रवार र नवरात्रिमा इनको पूजा विशेष गरिन्छ।',
      en: 'Goddess Durga is the deity of power and protection. She is especially worshipped on Fridays and during Navratri.',
    ),
    mantra: LocalizedText(
      hi: 'ॐ दुं दुर्गायै नमः',
      ne: 'ॐ दुं दुर्गायै नमः',
      en: 'Om Dum Durgayei Namah',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: हे माँ दुर्गा, हमें सभी बाधाओं और भय से मुक्त करें।',
      ne: 'भावार्थ: हे माँ दुर्गा, हामीलाई सबै बाधा र भयबाट मुक्त गर्नुहोस्।',
      en: 'Meaning: O Mother Durga, free us from all obstacles and fears.',
    ),
    themeColorHex: 0xFFE53935, // Deep Red (Kumkum)
  );

  static const GodModel krishna = GodModel(
    id: 'krishna',
    name: LocalizedText(
      hi: 'श्री कृष्ण',
      ne: 'श्री कृष्ण',
      en: 'Lord Krishna',
    ),
    imagePath: AssetPaths.krishnaJi,
    shortDescription: LocalizedText(
      hi: 'भगवान श्री कृष्ण प्रेम, ज्ञान और लीला के अवतार हैं। बुधवार को इनकी पूजा विशेष फलदायी होती है।',
      ne: 'भगवान श्री कृष्ण प्रेम, ज्ञान र लीलाका अवतार हुनुहुन्छ। बुधवारमा इनको पूजा विशेष फलदायी हुन्छ।',
      en: 'Lord Krishna is the avatar of love, wisdom, and divine play. Worshipping him on Wednesday is especially fruitful.',
    ),
    mantra: LocalizedText(
      hi: 'ॐ नमो भगवते वासुदेवाय',
      ne: 'ॐ नमो भगवते वासुदेवाय',
      en: 'Om Namo Bhagavate Vasudevaya',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: हे वासुदेव श्री कृष्ण, हम आपको नमन करते हैं।',
      ne: 'भावार्थ: हे वासुदेव श्री कृष्ण, हामी तपाईंलाई नमन गर्दछौं।',
      en: 'Meaning: O Lord Vasudeva Krishna, we bow to you.',
    ),
    themeColorHex: 0xFF1E88E5, // Blue (Krishna's divine blue)
  );

  static const GodModel ram = GodModel(
    id: 'ram',
    name: LocalizedText(
      hi: 'श्री राम',
      ne: 'श्री राम',
      en: 'Lord Ram',
    ),
    imagePath: AssetPaths.ramJi,
    shortDescription: LocalizedText(
      hi: 'मर्यादा पुरुषोत्तम श्री राम धर्म, सत्य और मर्यादा के प्रतीक हैं। रविवार और गुरुवार को इनकी पूजा विशेष होती है।',
      ne: 'मर्यादा पुरुषोत्तम श्री राम धर्म, सत्य र मर्यादाका प्रतीक हुनुहुन्छ। आइतवार र बिहीवारमा इनको पूजा विशेष हुन्छ।',
      en: 'Lord Ram is the embodiment of righteousness, truth, and virtue. He is especially worshipped on Sundays and Thursdays.',
    ),
    mantra: LocalizedText(
      hi: 'श्री राम जय राम जय जय राम',
      ne: 'श्री राम जय राम जय जय राम',
      en: 'Shri Ram Jai Ram Jai Jai Ram',
    ),
    mantraMeaning: LocalizedText(
      hi: 'भावार्थ: मर्यादा पुरुषोत्तम प्रभु श्री राम का परम पावन नाम।',
      ne: 'भावार्थ: मर्यादा पुरुषोत्तम प्रभु श्री रामको परम पावन नाम।',
      en: 'Meaning: The most sacred name of Lord Ram, the supreme ideal of righteousness.',
    ),
    themeColorHex: 0xFFFF8F00, // Golden / Amber
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Complete list of all Gods
  // ─────────────────────────────────────────────────────────────────────────

  /// Master list of all Gods. Add new Gods here.
  static const List<GodModel> allGods = [
    hanuman,
    shiva,
    ganesha,
    durga,
    krishna,
    ram,
  ];

  /// Quick lookup by ID. Returns null if not found.
  static GodModel? getById(String id) {
    for (final god in allGods) {
      if (god.id == id) return god;
    }
    return null;
  }

  /// Quick lookup by ID with fallback to Hanuman.
  static GodModel getByIdOrDefault(String id) {
    return getById(id) ?? hanuman;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Weekday → God Mapping
  // ─────────────────────────────────────────────────────────────────────────
  //
  // Uses DateTime weekday constants: Monday=1, Tuesday=2, ... Sunday=7
  //
  // Traditional Hindu weekday deity associations:
  //   Monday    = Shiva
  //   Tuesday   = Hanuman
  //   Wednesday = Ganesha / Krishna
  //   Thursday  = Vishnu / Ram
  //   Friday    = Durga / Lakshmi
  //   Saturday  = Hanuman / Shani (we use Hanuman)
  //   Sunday    = Ram / Surya

  /// Maps each weekday (1=Mon .. 7=Sun) to the primary God's ID.
  static const Map<int, String> weekdayGodMap = {
    DateTime.monday:    'shiva',    // सोमवार → भगवान शिव
    DateTime.tuesday:   'hanuman',  // मंगलवार → हनुमान जी
    DateTime.wednesday: 'ganesha',  // बुधवार → गणेश जी
    DateTime.thursday:  'ram',      // गुरुवार → श्री राम
    DateTime.friday:    'durga',    // शुक्रवार → माँ दुर्गा
    DateTime.saturday:  'hanuman',  // शनिवार → हनुमान जी
    DateTime.sunday:    'ram',      // रविवार → श्री राम
  };

  /// Weekday names in 3 languages for display.
  static const Map<int, LocalizedText> weekdayNames = {
    DateTime.monday: LocalizedText(
      hi: 'सोमवार', ne: 'सोमवार', en: 'Monday',
    ),
    DateTime.tuesday: LocalizedText(
      hi: 'मंगलवार', ne: 'मङ्गलवार', en: 'Tuesday',
    ),
    DateTime.wednesday: LocalizedText(
      hi: 'बुधवार', ne: 'बुधवार', en: 'Wednesday',
    ),
    DateTime.thursday: LocalizedText(
      hi: 'गुरुवार', ne: 'बिहीवार', en: 'Thursday',
    ),
    DateTime.friday: LocalizedText(
      hi: 'शुक्रवार', ne: 'शुक्रवार', en: 'Friday',
    ),
    DateTime.saturday: LocalizedText(
      hi: 'शनिवार', ne: 'शनिवार', en: 'Saturday',
    ),
    DateTime.sunday: LocalizedText(
      hi: 'रविवार', ne: 'आइतवार', en: 'Sunday',
    ),
  };

  /// Returns the God for today's weekday.
  static GodModel getWeekdayGod([DateTime? date]) {
    final weekday = (date ?? DateTime.now()).weekday;
    final godId = weekdayGodMap[weekday] ?? 'hanuman';
    return getByIdOrDefault(godId);
  }

  /// Returns the weekday special label for a God on a given day.
  /// Example: "मंगलवार विशेष • संकटमोचन"
  static LocalizedText getWeekdayBadge(int weekday) {
    final dayName = weekdayNames[weekday];
    final godId = weekdayGodMap[weekday] ?? 'hanuman';
    final god = getByIdOrDefault(godId);
    return LocalizedText(
      hi: '${dayName?.hi ?? ''} विशेष • ${god.name.hi}',
      ne: '${dayName?.ne ?? ''} विशेष • ${god.name.ne}',
      en: '${dayName?.en ?? ''} Special • ${god.name.en}',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Default Mantras (for Jaap screen)
  // ─────────────────────────────────────────────────────────────────────────

  /// Master list of mantras available for Jaap.
  /// Each mantra links back to a God via [relatedGodId].
  static const List<MantraModel> defaultMantras = [
    MantraModel(
      id: 'ram',
      name: LocalizedText(
        hi: 'श्री राम जय राम',
        ne: 'श्री राम जय राम',
        en: 'Shri Ram Jai Ram',
      ),
      mantraText: 'श्री राम जय राम जय जय राम',
      deity: LocalizedText(
        hi: 'श्री राम',
        ne: 'श्री राम',
        en: 'Lord Ram',
      ),
      meaning: LocalizedText(
        hi: 'मर्यादा पुरुषोत्तम प्रभु श्री राम का परम पावन नाम',
        ne: 'मर्यादा पुरुषोत्तम प्रभु श्री रामको परम पावन नाम',
        en: 'The most sacred name of Lord Ram, ideal of righteousness',
      ),
      relatedGodId: 'ram',
    ),
    MantraModel(
      id: 'shiva',
      name: LocalizedText(
        hi: 'ॐ नमः शिवाय',
        ne: 'ॐ नमः शिवाय',
        en: 'Om Namah Shivaya',
      ),
      mantraText: 'ॐ नमः शिवाय',
      deity: LocalizedText(
        hi: 'भगवान शिव',
        ne: 'भगवान शिव',
        en: 'Lord Shiva',
      ),
      meaning: LocalizedText(
        hi: 'सदाशिव भगवान भोलेनाथ का पंचाक्षरी महामंत्र',
        ne: 'सदाशिव भगवान भोलेनाथको पञ्चाक्षरी महामन्त्र',
        en: 'The five-syllable Mahamantra of Lord Shiva',
      ),
      relatedGodId: 'shiva',
    ),
    MantraModel(
      id: 'krishna',
      name: LocalizedText(
        hi: 'हरे कृष्ण हरे राम',
        ne: 'हरे कृष्ण हरे राम',
        en: 'Hare Krishna Hare Rama',
      ),
      mantraText: 'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे\nहरे राम हरे राम राम राम हरे हरे',
      deity: LocalizedText(
        hi: 'श्री कृष्ण व श्री राम',
        ne: 'श्री कृष्ण र श्री राम',
        en: 'Lord Krishna & Lord Ram',
      ),
      meaning: LocalizedText(
        hi: 'कलिकल्मषनाशन महामंत्र — कलियुग का तारक मंत्र',
        ne: 'कलिकल्मषनाशन महामन्त्र — कलियुगको तारक मन्त्र',
        en: 'The great mantra that destroys sins of Kali Yuga',
      ),
      relatedGodId: 'krishna',
    ),
    MantraModel(
      id: 'gayatri',
      name: LocalizedText(
        hi: 'गायत्री महामंत्र',
        ne: 'गायत्री महामन्त्र',
        en: 'Gayatri Mahamantra',
      ),
      mantraText: 'ॐ भूर्भुवः स्वः\nतत्सवितुर्वरेण्यं\nभर्गो देवस्य धीमहि\nधियो यो नः प्रचोदयात्॥',
      deity: LocalizedText(
        hi: 'माँ गायत्री / सविता देव',
        ne: 'माँ गायत्री / सविता देव',
        en: 'Goddess Gayatri / Sun God',
      ),
      meaning: LocalizedText(
        hi: 'सर्वोत्तम वैदिक मंत्र — बुद्धि और आत्मज्ञान प्रदान करे',
        ne: 'सर्वोत्तम वैदिक मन्त्र — बुद्धि र आत्मज्ञान प्रदान गर्नुहोस्',
        en: 'The supreme Vedic mantra — bestows wisdom and self-knowledge',
      ),
      relatedGodId: null, // Universal mantra
    ),
    MantraModel(
      id: 'ganesha',
      name: LocalizedText(
        hi: 'ॐ गं गणपतये नमः',
        ne: 'ॐ गं गणपतये नमः',
        en: 'Om Gam Ganapataye Namah',
      ),
      mantraText: 'ॐ गं गणपतये नमः',
      deity: LocalizedText(
        hi: 'श्री गणेश',
        ne: 'श्री गणेश',
        en: 'Lord Ganesha',
      ),
      meaning: LocalizedText(
        hi: 'विघ्नहर्ता श्री गणेश का सिद्ध बीज मंत्र',
        ne: 'विघ्नहर्ता श्री गणेशको सिद्ध बीज मन्त्र',
        en: 'The powerful seed mantra of Lord Ganesha, remover of obstacles',
      ),
      relatedGodId: 'ganesha',
    ),
    MantraModel(
      id: 'hanuman',
      name: LocalizedText(
        hi: 'ॐ हं हनुमते नमः',
        ne: 'ॐ हं हनुमते नमः',
        en: 'Om Ham Hanumate Namah',
      ),
      mantraText: 'ॐ हं हनुमते नमः',
      deity: LocalizedText(
        hi: 'श्री हनुमान जी',
        ne: 'श्री हनुमान जी',
        en: 'Lord Hanuman',
      ),
      meaning: LocalizedText(
        hi: 'बजरंगबली हनुमान जी का शक्तिशाली बीज मंत्र',
        ne: 'बजरङ्गबली हनुमान जीको शक्तिशाली बीज मन्त्र',
        en: 'The powerful seed mantra of Lord Hanuman',
      ),
      relatedGodId: 'hanuman',
    ),
    MantraModel(
      id: 'durga',
      name: LocalizedText(
        hi: 'ॐ दुं दुर्गायै नमः',
        ne: 'ॐ दुं दुर्गायै नमः',
        en: 'Om Dum Durgayei Namah',
      ),
      mantraText: 'ॐ दुं दुर्गायै नमः',
      deity: LocalizedText(
        hi: 'माँ दुर्गा',
        ne: 'माँ दुर्गा',
        en: 'Goddess Durga',
      ),
      meaning: LocalizedText(
        hi: 'शक्ति स्वरूपा माँ दुर्गा का सिद्ध मंत्र — भय और बाधा का नाश करे',
        ne: 'शक्ति स्वरूपा माँ दुर्गाको सिद्ध मन्त्र — भय र बाधाको नाश गर्नुहोस्',
        en: 'The powerful mantra of Goddess Durga — destroys fear and obstacles',
      ),
      relatedGodId: 'durga',
    ),
  ];

  /// Find a mantra by ID. Returns first mantra (Ram) as fallback.
  static MantraModel getMantraById(String id) {
    for (final mantra in defaultMantras) {
      if (mantra.id == id) return mantra;
    }
    return defaultMantras.first;
  }

  /// Get mantras related to a specific God.
  static List<MantraModel> getMantrasForGod(String godId) {
    return defaultMantras
        .where((m) => m.relatedGodId == godId)
        .toList();
  }
}
