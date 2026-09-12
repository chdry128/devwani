// ══════════════════════════════════════════════════════════════════════════════
// MANTRA MODEL — Sacred mantra with tri-language support
// ══════════════════════════════════════════════════════════════════════════════
//
// Each mantra is linked to a God and has a configurable target count
// (default 108 = one mala). The tri-language fields allow the Jaap screen
// to display mantra name and meaning in the user's chosen language.

import 'god_model.dart';

/// Represents a sacred mantra for the Jaap (chanting) counter.
class MantraModel {
  /// Unique identifier (e.g. 'ram', 'shiva', 'gayatri')
  final String id;

  /// Tri-language mantra name / display label
  final LocalizedText name;

  /// The actual mantra text (in Devanagari — same across Hindi/Nepali)
  final String mantraText;

  /// Tri-language deity attribution
  final LocalizedText deity;

  /// Tri-language meaning / significance
  final LocalizedText meaning;

  /// ID of the related God (links to GodModel.id).
  /// Can be null for universal mantras like Gayatri.
  final String? relatedGodId;

  /// Number of repetitions per mala (default: 108)
  final int targetCount;

  const MantraModel({
    required this.id,
    required this.name,
    required this.mantraText,
    required this.deity,
    required this.meaning,
    this.relatedGodId,
    this.targetCount = 108,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MantraModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MantraModel($id)';
}
