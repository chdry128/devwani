// ══════════════════════════════════════════════════════════════════════════════
// AAJ KI AARTI SERVICE — Daily Aarti Selection & Asset Matcher Engine
// ══════════════════════════════════════════════════════════════════════════════
//
// Automatically selects today's Aarti for senior devotees following the strict
// 4-tier priority rules:
//   Priority 1: Major festival / special occasion today
//   Priority 2: Day of the week (Mon=Shiva, Tue=Hanuman, Wed=Ganesh, etc.)
//   Priority 3: User's preferred God (chosen during onboarding)
//   Priority 4: Sensible fallback (Hanuman Chalisa or Shiv Aarti)
//
// Also manages matching audio files with .txt lyrics files from assets/audio/aarti/
// and safely loading offline lyrics text with error resiliency.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../constants/app_festivals.dart';
import '../constants/app_gods.dart';
import '../constants/asset_paths.dart';
import '../models/aarti_item.dart';
import '../models/god_model.dart';

class AajKiAartiService {
  // In-memory cache for loaded lyrics so we don't reload file repeatedly
  static final Map<String, String> _lyricsCache = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Asset Registry — Mappings between Audio files & matching .txt Lyrics
  // ─────────────────────────────────────────────────────────────────────────

  /// Hanuman Chalisa
  static const AartiItem hanumanChalisa = AartiItem(
    id: 'hanuman_chalisa',
    title: LocalizedText(
      hi: 'श्री हनुमान चालीसा',
      ne: 'श्री हनुमान चालीसा',
      en: 'Shri Hanuman Chalisa',
    ),
    subtitle: LocalizedText(
      hi: 'संकट मोचन कृपा • महाबलशाली',
      ne: 'सङ्कट मोचन कृपा • महाबलशाली',
      en: 'Dispeller of all Sorrows',
    ),
    relatedGodId: 'hanuman',
    godName: LocalizedText(
      hi: 'श्री हनुमान जी',
      ne: 'श्री हनुमान जी',
      en: 'Lord Hanuman',
    ),
    audioPath: 'assets/audio/aarti/HanumanChalisa (1).mp3',
    lyricsPath: 'assets/audio/aarti/HanumanChalisa-Lycris.txt',
    imagePath: AssetPaths.hanumanJi,
    days: [DateTime.tuesday, DateTime.saturday],
    festivalIds: ['hanuman_jayanti'],
    isDefault: true,
    duration: Duration(minutes: 9, seconds: 42),
  );

  /// Hanuman Ji Ki Aarti
  static const AartiItem hanumanJiAarti = AartiItem(
    id: 'hanuman_ji_aarti',
    title: LocalizedText(
      hi: 'श्री हनुमान जी की आरती',
      ne: 'श्री हनुमान जीको आरती',
      en: 'Shri Hanuman Ji Ki Aarti',
    ),
    subtitle: LocalizedText(
      hi: 'आरती कीजै हनुमान लला की',
      ne: 'आरती कीजै हनुमान लला की',
      en: 'Aarti Kije Hanuman Lala Ki',
    ),
    relatedGodId: 'hanuman',
    godName: LocalizedText(
      hi: 'श्री हनुमान जी',
      ne: 'श्री हनुमान जी',
      en: 'Lord Hanuman',
    ),
    audioPath: 'assets/audio/aarti/HanumanJiKIAarti (1).mp3',
    lyricsPath: 'assets/audio/aarti/HanumanJiKiAarti-Lycris.txt',
    imagePath: AssetPaths.hanumanJi,
    days: [DateTime.tuesday, DateTime.saturday],
    festivalIds: ['hanuman_jayanti'],
    isDefault: false,
    duration: Duration(minutes: 5, seconds: 45),
  );

  /// Lord Shiva - Om Jai Shiv Omkara
  static const AartiItem shivAarti = AartiItem(
    id: 'om_jai_shiv_omkara',
    title: LocalizedText(
      hi: 'ॐ जय शिव ओंकारा',
      ne: 'ॐ जय शिव ओंकारा',
      en: 'Om Jai Shiv Omkara',
    ),
    subtitle: LocalizedText(
      hi: 'महादेव शिव शंकर आरती',
      ne: 'महादेव शिव शङ्कर आरती',
      en: 'Lord Shiva Mahadeva Aarti',
    ),
    relatedGodId: 'shiva',
    godName: LocalizedText(
      hi: 'भगवान शिव',
      ne: 'भगवान शिव',
      en: 'Lord Shiva',
    ),
    audioPath: 'assets/audio/aarti/OmJaiShivOmkaraShivAarti1.mp3',
    lyricsPath: 'assets/audio/aarti/OmJaiShivOmkara-lycrics.txt',
    imagePath: AssetPaths.shivaJi,
    days: [DateTime.monday],
    festivalIds: ['mahashivratri'],
    isDefault: true,
    duration: Duration(minutes: 5, seconds: 12),
  );

  /// Lord Ganesha - Jai Ganesh Deva
  static const AartiItem ganeshAarti = AartiItem(
    id: 'jai_ganesh_deva',
    title: LocalizedText(
      hi: 'जय गणेश जय गणेश देवा',
      ne: 'जय गणेश जय गणेश देवा',
      en: 'Jai Ganesh Jai Ganesh Deva',
    ),
    subtitle: LocalizedText(
      hi: 'विघ्नहर्ता श्री गणेश आरती',
      ne: 'विघ्नहर्ता श्री गणेश आरती',
      en: 'Remover of Obstacles',
    ),
    relatedGodId: 'ganesha',
    godName: LocalizedText(
      hi: 'श्री गणेश जी',
      ne: 'श्री गणेश जी',
      en: 'Lord Ganesha',
    ),
    audioPath: 'assets/audio/aarti/Jai-Ganesh-Jai-Ganesh-Deva-Ganes.mp3',
    lyricsPath: 'assets/audio/aarti/Jai-Ganesh-Jai-Ganesh-Lycrics.txt',
    imagePath: AssetPaths.ganeshaJi,
    days: [DateTime.wednesday],
    festivalIds: ['ganesh_chaturthi'],
    isDefault: true,
    duration: Duration(minutes: 3, seconds: 42),
  );

  /// Lord Vishnu / Universal - Om Jai Jagdish Hare
  static const AartiItem jagdishAarti = AartiItem(
    id: 'om_jai_jagdish_hare',
    title: LocalizedText(
      hi: 'ॐ जय जगदीश हरे',
      ne: 'ॐ जय जगदीश हरे',
      en: 'Om Jai Jagdish Hare',
    ),
    subtitle: LocalizedText(
      hi: 'सर्वकल्याणकारी महाआरती',
      ne: 'सर्वकल्याणकारी महाआरती',
      en: 'Universal Sacred Aarti',
    ),
    relatedGodId: 'ram',
    godName: LocalizedText(
      hi: 'भगवान श्री हरि विष्णु',
      ne: 'भगवान श्री हरि विष्णु',
      en: 'Lord Vishnu',
    ),
    audioPath: 'assets/audio/aarti/OM-JAI-JAGDISH-HARE.mp3',
    lyricsPath: 'assets/audio/aarti/Om-Jai-Jagadish-Hare-Lycrics.txt',
    imagePath: AssetPaths.ramJi,
    days: [DateTime.thursday, DateTime.sunday, DateTime.friday],
    festivalIds: ['diwali', 'ram_navami', 'navratri_1', 'navratri_8', 'navratri_9'],
    isDefault: true,
    duration: Duration(minutes: 5, seconds: 34),
  );

  /// Lord Krishna - Aarti Kunj Bihari Ki
  static const AartiItem krishnaAarti = AartiItem(
    id: 'aarti_kunj_bihari_ki',
    title: LocalizedText(
      hi: 'आरती कुंजबिहारी की',
      ne: 'आरती कुञ्जबिहारीको',
      en: 'Aarti Kunj Bihari Ki',
    ),
    subtitle: LocalizedText(
      hi: 'श्री गिरिधर कृष्ण मुरारी',
      ne: 'श्री गिरिधर कृष्ण मुरारी',
      en: 'Shri Giridhar Krishna Murari',
    ),
    relatedGodId: 'krishna',
    godName: LocalizedText(
      hi: 'भगवान श्री कृष्ण',
      ne: 'भगवान श्री कृष्ण',
      en: 'Lord Krishna',
    ),
    audioPath: 'assets/audio/aarti/Aarti-Kunj-Bihari-Ki-Aarti-Kunjconvv.mp3',
    lyricsPath: 'assets/audio/aarti/Aarti-Kunj-Bihari-Ki-Lyrcis.txt',
    imagePath: AssetPaths.krishnaJi,
    days: [DateTime.wednesday, DateTime.sunday],
    festivalIds: ['janmashtami'],
    isDefault: true,
    duration: Duration(minutes: 3, seconds: 38),
  );

  /// Complete list of all registered Aartis
  static const List<AartiItem> allAartis = [
    hanumanChalisa,
    shivAarti,
    ganeshAarti,
    jagdishAarti,
    krishnaAarti,
    hanumanJiAarti,
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Automated File Matcher & God Detection
  // ─────────────────────────────────────────────────────────────────────────

  /// Given an audio filename or path, detects the related God ID.
  static String detectGodFromFileName(String filename) {
    final lower = filename.toLowerCase();
    if (lower.contains('hanuman') || lower.contains('chalisa') || lower.contains('bajrang')) {
      return 'hanuman';
    }
    if (lower.contains('shiv') || lower.contains('omkara') || lower.contains('bholenath')) {
      return 'shiva';
    }
    if (lower.contains('ganesh') || lower.contains('ganpati') || lower.contains('vinayak')) {
      return 'ganesha';
    }
    if (lower.contains('krishna') || lower.contains('kunj') || lower.contains('bihari')) {
      return 'krishna';
    }
    if (lower.contains('jagdish') || lower.contains('vishnu') || lower.contains('ram')) {
      return 'ram';
    }
    if (lower.contains('durga') || lower.contains('ambe') || lower.contains('devi')) {
      return 'durga';
    }
    return 'hanuman'; // default
  }

  /// Finds an AartiItem matching the provided audio file path
  static AartiItem? getAartiByAudioPath(String path) {
    for (final aarti in allAartis) {
      if (aarti.audioPath == path) return aarti;
    }
    return null;
  }

  /// Finds an AartiItem by its unique ID
  static AartiItem? getAartiById(String id) {
    for (final aarti in allAartis) {
      if (aarti.id == id) return aarti;
    }
    return null;
  }

  /// Returns the primary default Aarti for a given God ID
  static AartiItem getDefaultForGod(String godId) {
    for (final aarti in allAartis) {
      if (aarti.relatedGodId == godId && aarti.isDefault) {
        return aarti;
      }
    }
    for (final aarti in allAartis) {
      if (aarti.relatedGodId == godId) {
        return aarti;
      }
    }
    return hanumanChalisa;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRIORITY SELECTION LOGIC — The Core Brain of "Aaj ki Aarti"
  // ─────────────────────────────────────────────────────────────────────────

  /// Selects the most auspicious Aarti for today according to the 4-tier priority:
  ///   1. Major festival / special occasion today
  ///   2. Day of the week (Monday = Shiva, Tuesday = Hanuman, etc.)
  ///   3. User's preferred God (selected during onboarding)
  ///   4. Sensible default fallback (Hanuman Chalisa or Shiv Aarti)
  static AartiItem selectTodaysAarti({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) {
    final today = date ?? DateTime.now();

    // ─── Priority 1: Major Festival / Special Occasion Today ─────────────
    final festival = AppFestivals.getActiveFestival(today);
    if (festival != null) {
      // Find Aarti matching this festival or festival's related God
      AartiItem? festivalAarti;
      for (final aarti in allAartis) {
        if (aarti.festivalIds.contains(festival.id)) {
          festivalAarti = aarti;
          break;
        }
      }
      festivalAarti ??= getDefaultForGod(festival.relatedGodId);

      return festivalAarti.copyWith(
        selectionReason: AartiSelectionReason.festival,
        selectionBadge: LocalizedText(
          hi: '🎪 ${festival.name.hi} विशेष',
          ne: '🎪 ${festival.name.ne} विशेष',
          en: '🎪 ${festival.name.en} Special',
        ),
      );
    }

    // ─── Priority 2: Day of the Week ────────────────────────────────────
    // Weekday Mapping:
    //   Monday (1)    = Shiva (Om Jai Shiv Omkara)
    //   Tuesday (2)   = Hanuman (Hanuman Chalisa)
    //   Wednesday (3) = Ganesha (Jai Ganesh Deva)
    //   Thursday (4)  = Vishnu / Ram (Om Jai Jagdish Hare)
    //   Friday (5)    = Durga / Jagdish Hare (Om Jai Jagdish Hare)
    //   Saturday (6)  = Hanuman (Hanuman Chalisa / Aarti)
    //   Sunday (7)    = Krishna / Surya (Aarti Kunj Bihari Ki / Jagdish Hare)
    final weekdayAarti = _getAartiForWeekday(today.weekday);
    if (weekdayAarti != null) {
      final dayBadge = AppGods.getWeekdayBadge(today.weekday);
      return weekdayAarti.copyWith(
        selectionReason: AartiSelectionReason.weekday,
        selectionBadge: dayBadge,
      );
    }

    // ─── Priority 3: User's Preferred God ───────────────────────────────
    if (preferredGodIds.isNotEmpty) {
      final godId = preferredGodIds.first;
      final preferredAarti = getDefaultForGod(godId);
      final god = AppGods.getByIdOrDefault(godId);

      return preferredAarti.copyWith(
        selectionReason: AartiSelectionReason.userPreference,
        selectionBadge: LocalizedText(
          hi: '🙏 आपके आराध्य • ${god.name.hi}',
          ne: '🙏 तपाईंका आराध्य • ${god.name.ne}',
          en: '🙏 Your Deity • ${god.name.en}',
        ),
      );
    }

    // ─── Priority 4: Sensible Default (Hanuman Chalisa) ──────────────────
    return hanumanChalisa.copyWith(
      selectionReason: AartiSelectionReason.fallback,
      selectionBadge: const LocalizedText(
        hi: '🙏 श्री हनुमान चालीसा • नित्य पाठ',
        ne: '🙏 श्री हनुमान चालीसा • नित्य पाठ',
        en: '🙏 Shri Hanuman Chalisa • Daily Recitation',
      ),
    );
  }

  /// Maps weekday index (1=Monday ... 7=Sunday) to specific Aarti
  static AartiItem? _getAartiForWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return shivAarti;
      case DateTime.tuesday:
        return hanumanChalisa;
      case DateTime.wednesday:
        return ganeshAarti;
      case DateTime.thursday:
        return jagdishAarti;
      case DateTime.friday:
        return jagdishAarti; // Friday Lakshmi/Vishnu devotion
      case DateTime.saturday:
        return hanumanChalisa;
      case DateTime.sunday:
        return krishnaAarti;
      default:
        return hanumanChalisa;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Offline Lyrics Loader & Cache
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads lyrics text safely from assets using the matching .txt file path.
  /// Includes in-memory caching and fallback if file cannot be read.
  static Future<String> loadLyrics(
    String lyricsPath, {
    AssetBundle? bundle,
  }) async {
    // Check in-memory cache first for instant retrieval
    if (_lyricsCache.containsKey(lyricsPath)) {
      return _lyricsCache[lyricsPath]!;
    }

    try {
      final activeBundle = bundle ?? rootBundle;
      final content = await activeBundle.loadString(lyricsPath);
      final cleaned = _cleanLyricsText(content);
      _lyricsCache[lyricsPath] = cleaned;
      return cleaned;
    } catch (e) {
      debugPrint('AajKiAartiService: Error loading lyrics from $lyricsPath: $e');
      // Graceful elderly-friendly fallback message so screen never crashes
      return 'आरती के पावन बोल शीघ्र ही उपलब्ध होंगे।\n\n'
          'भक्ति भाव से श्रवण करें और प्रभु का ध्यान लगाएं।\n'
          'हरि ॐ तत्सत् ॥';
    }
  }

  /// Pre-fetches and attaches loaded lyrics text directly to an AartiItem
  static Future<AartiItem> populateLyrics(
    AartiItem item, {
    AssetBundle? bundle,
  }) async {
    final lyrics = await loadLyrics(item.lyricsPath, bundle: bundle);
    return item.copyWith(rawLyrics: lyrics);
  }

  /// Cleans and formats raw lyrics string for elderly readability
  static String _cleanLyricsText(String raw) {
    // Normalize newlines and trim leading/trailing whitespace
    String text = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

    // Collapse multiple blank lines into double newlines for clear stanza separation
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return text;
  }

  /// Clears the lyrics cache (useful for testing or memory release)
  static void clearCache() {
    _lyricsCache.clear();
  }
}
