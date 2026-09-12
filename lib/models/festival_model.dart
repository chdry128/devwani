// ══════════════════════════════════════════════════════════════════════════════
// FESTIVAL MODEL — Hindu festival representation
// ══════════════════════════════════════════════════════════════════════════════
//
// Festivals drive the highest-priority logic in "Aaj ki Aarti" and
// "God of the Day". When a major festival falls today, the entire app
// experience revolves around that festival's deity.

import 'god_model.dart';

/// Represents a major Hindu festival.
///
/// Since Hindu festivals follow the lunar calendar and shift every year,
/// we store an approximate Gregorian month/day range for offline fallback.
/// For production accuracy, replace with year-specific date lookup or API.
class FestivalModel {
  /// Unique identifier (e.g. 'hanuman_jayanti', 'mahashivratri')
  final String id;

  /// Tri-language display name
  final LocalizedText name;

  /// Tri-language short description
  final LocalizedText description;

  /// ID of the God primarily associated with this festival
  final String relatedGodId;

  /// Approximate Gregorian month (1-12) when this festival usually falls.
  /// Used for rough offline date matching.
  final int approximateMonth;

  /// Approximate day of the month (1-31).
  /// Combined with [approximateMonth] for offline fallback matching.
  final int approximateDay;

  /// How many days around the approximate date to consider as "festival period".
  /// Default is 0 (exact day only). Set to 1-2 for multi-day festivals like Navratri.
  final int flexDays;

  const FestivalModel({
    required this.id,
    required this.name,
    required this.description,
    required this.relatedGodId,
    required this.approximateMonth,
    required this.approximateDay,
    this.flexDays = 0,
  });

  /// Checks if the given [date] falls within this festival's approximate window.
  ///
  /// This is an offline approximation. For lunar-calendar accuracy, use
  /// a year-specific festival date table or API.
  bool isOnDate(DateTime date) {
    if (date.month != approximateMonth) return false;
    final diff = (date.day - approximateDay).abs();
    return diff <= flexDays;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FestivalModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FestivalModel($id)';
}
