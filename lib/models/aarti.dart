// ══════════════════════════════════════════════════════════════════════════════
// BACKWARDS COMPATIBILITY WRAPPER — Old Aarti → New AartiModel
// ══════════════════════════════════════════════════════════════════════════════
//
// This file preserves the old [Aarti] and [AartiVerse] API so existing
// screens (aarti_screen.dart, audio_provider.dart, etc.) continue to compile.
//
// New code should use [AartiModel] from 'aarti_model.dart' directly.
// This wrapper will be removed once all screens are migrated.

import '../constants/app_aartis.dart';
import '../models/aarti_model.dart' as new_model;

/// @deprecated Use [new_model.AartiVerse] from 'aarti_model.dart' instead.
class AartiVerse {
  final int index;
  final String text;
  final String? type;
  final Duration startTime;

  const AartiVerse({
    required this.index,
    required this.text,
    this.type,
    required this.startTime,
  });

  /// Convert from new model verse to old format.
  factory AartiVerse.fromNew(new_model.AartiVerse v) {
    return AartiVerse(
      index: v.index,
      text: v.text,
      type: v.type,
      startTime: v.startTime,
    );
  }
}

/// @deprecated Use [new_model.AartiModel] from 'aarti_model.dart' instead.
class Aarti {
  final String id;
  final String title;
  final String subtitle;
  final String deity;
  final String timeCategory;
  final String mood;
  final String imagePath;
  final Duration duration;
  final String audioAssetPath;
  final List<AartiVerse> verses;

  const Aarti({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.deity,
    required this.timeCategory,
    required this.mood,
    required this.imagePath,
    required this.duration,
    required this.audioAssetPath,
    required this.verses,
  });

  /// Convert a new [AartiModel] to the old [Aarti] format for a given language.
  factory Aarti.fromNew(new_model.AartiModel model, {String lang = 'hi'}) {
    return Aarti(
      id: model.id,
      title: model.title.forLang(lang),
      subtitle: model.subtitle.forLang(lang),
      deity: model.relatedGodId,
      timeCategory: model.timeCategory.forLang(lang),
      mood: model.mood.forLang(lang),
      imagePath: model.imagePath,
      duration: model.duration,
      audioAssetPath: model.audioPath,
      verses: model.verses.map((v) => AartiVerse.fromNew(v)).toList(),
    );
  }

  /// The old static default — Hanuman Chalisa.
  /// Now generated from the new [AppAartis.hanumanChalisa].
  static final Aarti defaultHanumanChalisa = Aarti.fromNew(
    AppAartis.hanumanChalisa,
    lang: 'hi',
  );
}
