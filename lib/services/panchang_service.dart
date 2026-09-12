// ══════════════════════════════════════════════════════════════════════════════
// PANCHANG SERVICE — Accurate Offline Tithi, Sunrise/Sunset, & Daily Rules
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/all.dart';

import '../constants/panchang_rules.dart';
import '../l10n/panchang_localizations.dart';
import '../models/daily_panchang.dart';

/// Clean, offline-first service for computing accurate Hindu Panchang data.
///
/// Powered by `tithi_engine` with per-city Swiss Ephemeris astronomical tables:
/// - Accurate Tithi calculation (Shukla/Krishna paksha, 1-30 tithi numbering)
/// - Exact Sunrise & Sunset calculation
/// - Kathmandu default (Nepal), with full Delhi (India) support
/// - 4 clean sections for elderly users (Tithi, Sun timings, 3 Dos, 3 Don'ts)
class PanchangService {
  PanchangService._();

  /// Cached engine instance with registered city ephemeris tables
  static final Panchang _panchang = Panchang([registerAllCities]);

  /// Default primary city (Kathmandu, Nepal)
  static const String defaultCityName = 'Kathmandu';

  /// Supported primary cities
  static const List<String> supportedCities = ['Kathmandu', 'Delhi'];

  /// Timezone offsets for primary locations
  static const Map<String, Duration> _cityTimezoneOffsets = {
    'kathmandu': Duration(hours: 5, minutes: 45), // NPT (Nepal Standard Time, UTC+5:45)
    'delhi': Duration(hours: 5, minutes: 30),     // IST (Indian Standard Time, UTC+5:30)
  };

  /// Time formatter: e.g. "06:28 AM"
  static final DateFormat _timeFormatter = DateFormat('hh:mm a');

  /// Main entry point: Computes and returns the complete [DailyPanchang].
  ///
  /// Parameters:
  /// - [date]: Optional date to query (defaults to today)
  /// - [city]: City name (defaults to 'Kathmandu', supports 'Delhi')
  /// - [lang]: App language code ('hi' - Hindi, 'ne' - Nepali, 'en' - English)
  static DailyPanchang getPanchang({
    DateTime? date,
    String city = defaultCityName,
    String lang = 'hi',
  }) {
    final targetDate = date ?? DateTime.now();

    try {
      // 1. Resolve City from tithi_engine registry
      final resolvedCity = City.tryOf(city) ??
          City.tryOf(defaultCityName) ??
          defaultCity;

      // 2. Compute Tithi for the given date and city
      final tithiInfo = _panchang.tithiOnDate(targetDate, resolvedCity);
      final formattedTithi = PanchangLocalizations.formatTithi(
        tithiInfo,
        lang: lang,
      );

      // 3. Compute Sunrise and Sunset (returned as UTC instants)
      final sunriseUtc = _panchang.sunrise(targetDate, resolvedCity);
      final sunsetUtc = _panchang.sunset(targetDate, resolvedCity);

      // 4. Convert UTC to city local time using timezone offset
      final offset = _getTimezoneOffset(city);
      final sunriseLocal = sunriseUtc.toUtc().add(offset);
      final sunsetLocal = sunsetUtc.toUtc().add(offset);

      final formattedSunrise = _timeFormatter.format(sunriseLocal);
      final formattedSunset = _timeFormatter.format(sunsetLocal);

      // 5. Evaluate simple, senior-friendly Do / Avoid guidance
      final ruleResult = PanchangRules.evaluate(
        rawTithiName: tithiInfo.tithiName,
        tithiNumber: tithiInfo.tithiNumber,
        weekday: targetDate.weekday,
        lang: lang,
      );

      return DailyPanchang(
        tithi: formattedTithi,
        sunrise: formattedSunrise,
        sunset: formattedSunset,
        doList: ruleResult.doList,
        avoidList: ruleResult.avoidList,
        date: targetDate,
        specialDay: ruleResult.specialDay,
        location: resolvedCity.name,
      );
    } catch (e, stackTrace) {
      // Graceful error handling: ensure elderly users always have a peaceful fallback
      debugPrint('PanchangService: Calculation error ($e). Falling back gracefully.');
      if (kDebugMode) {
        debugPrint(stackTrace.toString());
      }
      return _createFallbackPanchang(targetDate, city, lang);
    }
  }

  /// Convenience method for today's panchang
  static DailyPanchang getToday({
    String city = defaultCityName,
    String lang = 'hi',
  }) {
    return getPanchang(date: DateTime.now(), city: city, lang: lang);
  }

  /// Returns timezone offset for a city (defaults to Kathmandu UTC+5:45)
  static Duration _getTimezoneOffset(String city) {
    final key = city.trim().toLowerCase();
    return _cityTimezoneOffsets[key] ??
        const Duration(hours: 5, minutes: 45);
  }

  /// Creates a safe, localized fallback panchang if calculations ever fail
  static DailyPanchang _createFallbackPanchang(
    DateTime date,
    String city,
    String lang,
  ) {
    final ruleResult = PanchangRules.evaluate(
      rawTithiName: 'normal',
      tithiNumber: 1,
      weekday: date.weekday,
      lang: lang,
    );

    return DailyPanchang(
      tithi: PanchangLocalizations.fallbackTithi[lang] ??
          PanchangLocalizations.fallbackTithi['hi']!,
      sunrise: '06:00 AM',
      sunset: '06:00 PM',
      doList: ruleResult.doList,
      avoidList: ruleResult.avoidList,
      date: date,
      specialDay: PanchangLocalizations.fallbackSpecialDay[lang] ??
          PanchangLocalizations.fallbackSpecialDay['hi']!,
      location: city,
    );
  }
}
