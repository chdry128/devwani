// ══════════════════════════════════════════════════════════════════════════════
// PANCHANG LOCALIZATIONS — Tri-language support (Hindi, Nepali, English)
// ══════════════════════════════════════════════════════════════════════════════

import 'package:tithi_engine/tithi_engine.dart';

/// Clean and maintainable localization dictionary for Hindu calendar terms.
/// Supports Hindi (hi - primary), Nepali (ne), and English (en).
class PanchangLocalizations {
  PanchangLocalizations._();

  /// Paksha (Lunar Fortnight) names
  static const Map<String, Map<String, String>> _pakshaMap = {
    'shukla': {
      'hi': 'शुक्ल पक्ष',
      'ne': 'शुक्ल पक्ष',
      'en': 'Shukla Paksha',
    },
    'krishna': {
      'hi': 'कृष्ण पक्ष',
      'ne': 'कृष्ण पक्ष',
      'en': 'Krishna Paksha',
    },
  };

  /// Tithi names (1 to 15)
  static const Map<String, Map<String, String>> _tithiNames = {
    'pratipada': {'hi': 'प्रतिपदा', 'ne': 'प्रतिपदा', 'en': 'Pratipada'},
    'dwitiya': {'hi': 'द्वितीया', 'ne': 'द्वितीया', 'en': 'Dwitiya'},
    'tritiya': {'hi': 'तृतीया', 'ne': 'तृतीया', 'en': 'Tritiya'},
    'chaturthi': {'hi': 'चतुर्थी', 'ne': 'चतुर्थी', 'en': 'Chaturthi'},
    'panchami': {'hi': 'पंचमी', 'ne': 'पञ्चमी', 'en': 'Panchami'},
    'shashthi': {'hi': 'षष्ठी', 'ne': 'षष्ठी', 'en': 'Shashthi'},
    'saptami': {'hi': 'सप्तमी', 'ne': 'सप्तमी', 'en': 'Saptami'},
    'ashtami': {'hi': 'अष्टमी', 'ne': 'अष्टमी', 'en': 'Ashtami'},
    'navami': {'hi': 'नवमी', 'ne': 'नवमी', 'en': 'Navami'},
    'dashami': {'hi': 'दशमी', 'ne': 'दशमी', 'en': 'Dashami'},
    'ekadashi': {'hi': 'एकादशी', 'ne': 'एकादशी', 'en': 'Ekadashi'},
    'dwadashi': {'hi': 'द्वादशी', 'ne': 'द्वादशी', 'en': 'Dwadashi'},
    'trayodashi': {'hi': 'त्रयोदशी', 'ne': 'त्रयोदशी', 'en': 'Trayodashi'},
    'chaturdashi': {'hi': 'चतुर्दशी', 'ne': 'चतुर्दशी', 'en': 'Chaturdashi'},
    'purnima': {'hi': 'पूर्णिमा', 'ne': 'पूर्णिमा', 'en': 'Purnima'},
    'amavasya': {'hi': 'अमावस्या', 'ne': 'औंसी (अमावस्या)', 'en': 'Amavasya'},
  };

  /// Hindu Lunar Months
  static const Map<String, Map<String, String>> _monthNames = {
    'chaitra': {'hi': 'चैत्र', 'ne': 'चैत्र', 'en': 'Chaitra'},
    'vaishakha': {'hi': 'वैशाख', 'ne': 'वैशाख', 'en': 'Vaishakha'},
    'jyeshtha': {'hi': 'ज्येष्ठ', 'ne': 'जेठ', 'en': 'Jyeshtha'},
    'ashadha': {'hi': 'आषाढ़', 'ne': 'असार', 'en': 'Ashadha'},
    'shravana': {'hi': 'श्रावण', 'ne': 'साउन', 'en': 'Shravana'},
    'bhadrapada': {'hi': 'भाद्रपद', 'ne': 'भदौ', 'en': 'Bhadrapada'},
    'ashvina': {'hi': 'आश्विन', 'ne': 'असोज', 'en': 'Ashvina'},
    'kartika': {'hi': 'कार्तिक', 'ne': 'कात्तिक', 'en': 'Kartika'},
    'margashirsha': {'hi': 'मार्गशीर्ष', 'ne': 'मंसिर', 'en': 'Margashirsha'},
    'pausha': {'hi': 'पौष', 'ne': 'पुस', 'en': 'Pausha'},
    'magha': {'hi': 'माघ', 'ne': 'माघ', 'en': 'Magha'},
    'phalguna': {'hi': 'फाल्गुन', 'ne': 'फागुन', 'en': 'Phalguna'},
  };

  /// Translates Paksha into requested language
  static String getPakshaName(Paksha paksha, {String lang = 'hi'}) {
    final key = paksha == Paksha.shukla ? 'shukla' : 'krishna';
    return _pakshaMap[key]?[lang] ?? _pakshaMap[key]?['hi'] ?? key;
  }

  /// Translates Tithi name into requested language
  static String getTithiName(String tithiName, {String lang = 'hi'}) {
    final key = tithiName.trim().toLowerCase();
    return _tithiNames[key]?[lang] ?? _tithiNames[key]?['hi'] ?? tithiName;
  }

  /// Translates Lunar Month into requested language
  static String getMonthName(String monthName, {String lang = 'hi'}) {
    final key = monthName.trim().toLowerCase();
    return _monthNames[key]?[lang] ?? _monthNames[key]?['hi'] ?? monthName;
  }

  /// Formats the complete Tithi string cleanly for senior users.
  /// Example outputs:
  /// - Hindi: "शुक्ल पक्ष एकादशी" or "पूर्णिमा"
  /// - Nepali: "शुक्ल पक्ष एकादशी" or "पूर्णिमा"
  /// - English: "Shukla Paksha Ekadashi" or "Purnima"
  static String formatTithi(TithiInfo tithiInfo, {String lang = 'hi'}) {
    final rawName = tithiInfo.tithiName.trim().toLowerCase();
    final localizedTithiName = getTithiName(rawName, lang: lang);

    // Purnima and Amavasya stand elegantly on their own
    if (rawName == 'purnima' || rawName == 'amavasya') {
      return localizedTithiName;
    }

    final localizedPaksha = getPakshaName(tithiInfo.paksha, lang: lang);
    return '$localizedPaksha $localizedTithiName';
  }

  /// Fallback strings when calculations encounter errors
  static const Map<String, String> fallbackTithi = {
    'hi': 'शुभ तिथि (दैनिक पंचांग)',
    'ne': 'शुभ तिथि (दैनिक पञ्चाङ्ग)',
    'en': 'Auspicious Tithi (Daily Panchang)',
  };

  static const Map<String, String> fallbackSpecialDay = {
    'hi': 'आज का पावन दिन',
    'ne': 'आजको पावन दिन',
    'en': 'Sacred Day Today',
  };
}
