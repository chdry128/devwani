// ══════════════════════════════════════════════════════════════════════════════
// BACKWARDS COMPATIBILITY WRAPPER — Old PanchangData → New DailyPanchang
// ══════════════════════════════════════════════════════════════════════════════
//
// This file preserves the old [PanchangData] API so existing screens
// (panchang_screen.dart, panchang_provider.dart) continue to compile.
//
// New code should use [DailyPanchang] from 'daily_panchang.dart' directly.
// This wrapper will be removed once all screens are migrated.

import 'daily_panchang.dart';

/// @deprecated Use [DailyPanchang] from 'daily_panchang.dart' instead.
class PanchangData {
  final DateTime date;
  final String tithi;
  final String specialDay;
  final String sunrise;
  final String sunset;
  final List<String> dos;
  final List<String> donts;

  const PanchangData({
    required this.date,
    required this.tithi,
    required this.specialDay,
    required this.sunrise,
    required this.sunset,
    required this.dos,
    required this.donts,
  });

  /// Convert from new [DailyPanchang] to old [PanchangData] for a given language.
  factory PanchangData.fromNew(DailyPanchang panchang, {String lang = 'hi'}) {
    return PanchangData(
      date: panchang.date,
      tithi: panchang.tithi,
      specialDay: panchang.specialDay,
      sunrise: panchang.sunrise,
      sunset: panchang.sunset,
      dos: panchang.doList,
      donts: panchang.avoidList,
    );
  }

  /// Default sample panchang — now generated from the new data layer.
  static final PanchangData defaultToday = PanchangData.fromNew(
    DailyPanchang.sampleToday,
    lang: 'hi',
  );
}
