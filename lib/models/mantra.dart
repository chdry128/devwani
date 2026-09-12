// ══════════════════════════════════════════════════════════════════════════════
// BACKWARDS COMPATIBILITY WRAPPER — Old Mantra → New MantraModel
// ══════════════════════════════════════════════════════════════════════════════
//
// This file preserves the old [Mantra] API so existing screens
// (jaap_screen.dart, jaap_provider.dart) continue to compile.
//
// New code should use [MantraModel] from 'mantra_model.dart' directly.
// This wrapper will be removed once all screens are migrated.

import '../constants/app_gods.dart';
import '../models/mantra_model.dart' as new_model;

/// @deprecated Use [new_model.MantraModel] from 'mantra_model.dart' instead.
class Mantra {
  final String id;
  final String name;
  final String deity;
  final int targetCount;
  final String meaning;

  const Mantra({
    required this.id,
    required this.name,
    required this.deity,
    this.targetCount = 108,
    required this.meaning,
  });

  /// Convert from new MantraModel to old Mantra for a given language.
  factory Mantra.fromNew(new_model.MantraModel model, {String lang = 'hi'}) {
    return Mantra(
      id: model.id,
      name: model.name.forLang(lang),
      deity: model.deity.forLang(lang),
      targetCount: model.targetCount,
      meaning: model.meaning.forLang(lang),
    );
  }

  /// The old static default mantras list — now generated from the new data layer.
  static final List<Mantra> defaultMantras = AppGods.defaultMantras
      .map((m) => Mantra.fromNew(m, lang: 'hi'))
      .toList();
}
