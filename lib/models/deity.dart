// ══════════════════════════════════════════════════════════════════════════════
// BACKWARDS COMPATIBILITY WRAPPER — Old DeityOfDay → New GodModel
// ══════════════════════════════════════════════════════════════════════════════
//
// This file preserves the old [DeityOfDay] API so existing screens
// (home_screen.dart, more_screen.dart, etc.) continue to compile.
//
// New code should use [GodModel] from 'god_model.dart' directly.
// This wrapper will be removed once all screens are migrated.

import '../constants/asset_paths.dart';
import '../services/today_service.dart';

/// @deprecated Use [GodModel] from 'god_model.dart' instead.
class DeityOfDay {
  final String name;
  final String title;
  final String daySpecial;
  final String imagePath;
  final String description;
  final String mantraTitle;
  final String mantraText;
  final String mantraMeaning;
  final List<String> dos;
  final List<String> donts;

  const DeityOfDay({
    required this.name,
    required this.title,
    required this.daySpecial,
    required this.imagePath,
    required this.description,
    required this.mantraTitle,
    required this.mantraText,
    required this.mantraMeaning,
    required this.dos,
    required this.donts,
  });

  /// Creates a [DeityOfDay] from the new data layer for a given language.
  ///
  /// This bridges old screens to the new [TodayService] + [GodModel] system.
  static DeityOfDay fromToday({String lang = 'hi', List<String> preferredGodIds = const []}) {
    final result = TodayService.getToday(preferredGodIds: preferredGodIds);
    final god = result.god;
    final guidance = TodayService.getDailyGuidance(preferredGodIds: preferredGodIds);

    return DeityOfDay(
      name: god.name.forLang(lang),
      title: 'आज के देवता: ${god.name.forLang(lang)}',
      daySpecial: result.badge.forLang(lang),
      imagePath: god.imagePath,
      description: god.shortDescription.forLang(lang),
      mantraTitle: lang == 'en'
          ? '${god.name.forLang(lang)} Sacred Mantra'
          : (god.id == 'ganesha'
              ? 'सिद्ध गणेश महामंत्र'
              : '${god.name.forLang(lang)} महामंत्र'),
      mantraText: god.mantra.forLang(lang),
      mantraMeaning: god.mantraMeaning.forLang(lang),
      dos: guidance.dos.map((d) => d.forLang(lang)).toList(),
      donts: guidance.donts.map((d) => d.forLang(lang)).toList(),
    );
  }

  /// The old static [ganesha] constant — now generated from the new data layer.
  static final DeityOfDay ganesha = DeityOfDay(
    name: 'श्री गणेश जी',
    title: 'आज के देवता: श्री गणेश जी',
    daySpecial: 'बुधवार विशेष • विघ्नहर्ता',
    imagePath: AssetPaths.ganeshaJi,
    description:
        'भगवान श्री गणेश विघ्नहर्ता और प्रथम पूज्य देव हैं। आज के दिन गणेश जी का स्मरण करने से बुद्धि, सुख और शांति प्राप्त होती है।',
    mantraTitle: 'सिद्ध गणेश महामंत्र',
    mantraText: 'ॐ गं गणपतये नमः',
    mantraMeaning: 'भावार्थ: हे विघ्नहर्ता, हमारे सभी कष्ट दूर करें।',
    dos: const [
      'दूर्वा (दूब घास) और मोदक या लड्डू का भोग लगाएं',
      'माथे पर लाल सिंदूर या चंदन का तिलक लगाएं',
      'ॐ गं गणपतये नमः मंत्र का शांत मन से जप करें',
    ],
    donts: const [
      'गणेश जी की पूजा में तुलसी दल कभी न चढ़ाएं',
      'घर में किसी भी प्रकार का क्लेश या क्रोध न करें',
      'पूजा में टूटे या खंडित अक्षत (चावल) न अर्पित करें',
    ],
  );
}
