// ══════════════════════════════════════════════════════════════════════════════
// AARTI MODEL — Aarti / Chalisa / Stotra with day & festival linkage
// ══════════════════════════════════════════════════════════════════════════════
//
// Each Aarti knows which God it belongs to, which days of the week it is
// traditionally recited, and which festivals make it especially relevant.
// This enables the "Aaj ki Aarti" priority logic in [TodayService].

import 'god_model.dart';

/// A single verse / couplet in an Aarti or Chalisa.
///
/// Preserves the existing verse structure:
/// - [index] for ordering
/// - [text] is the Devanagari verse content
/// - [type] distinguishes 'दोहा' (Doha) from 'चौपाई' (Chaupai) etc.
/// - [startTime] for audio synchronization / karaoke highlighting
class AartiVerse {
  final int index;
  final String text;
  final String? type; // e.g. 'दोहा', 'चौपाई'
  final Duration startTime;

  const AartiVerse({
    required this.index,
    required this.text,
    this.type,
    required this.startTime,
  });
}

/// Represents an Aarti, Chalisa, or Stotra in the app.
class AartiModel {
  /// Unique identifier (e.g. 'hanuman_chalisa', 'shiv_aarti')
  final String id;

  /// Tri-language title for display
  final LocalizedText title;

  /// Tri-language subtitle (e.g. 'संकट मोचन कृपा')
  final LocalizedText subtitle;

  /// Path to the audio file in assets
  final String audioPath;

  /// Total duration of the audio
  final Duration duration;

  /// Path to the deity's image for the player screen
  final String imagePath;

  /// The verses / lyrics of the aarti
  final List<AartiVerse> verses;

  /// ID of the related God (links to GodModel.id)
  final String relatedGodId;

  /// Days of the week when this aarti is traditionally preferred.
  /// Uses DateTime weekday constants: Monday=1 ... Sunday=7
  final List<int> days;

  /// Festival IDs that make this aarti especially relevant.
  /// Links to FestivalModel.id
  final List<String> festivalIds;

  /// Whether this is the default/fallback aarti for its God.
  /// If a God has multiple aartis, the default one is picked first.
  final bool isDefault;

  /// Category label (e.g. 'प्रातः आरती', 'सायं आरती')
  final LocalizedText timeCategory;

  /// Mood label (e.g. 'भक्ति रस')
  final LocalizedText mood;

  const AartiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioPath,
    required this.duration,
    required this.imagePath,
    required this.verses,
    required this.relatedGodId,
    this.days = const [],
    this.festivalIds = const [],
    this.isDefault = false,
    required this.timeCategory,
    required this.mood,
  });

  /// Alias for verses to support alternative naming
  List<AartiVerse> get lyrics => verses;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AartiModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AartiModel($id)';
}
