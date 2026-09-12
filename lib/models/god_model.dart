// ══════════════════════════════════════════════════════════════════════════════
// GOD MODEL — Core deity representation for Devavani
// ══════════════════════════════════════════════════════════════════════════════
//
// Every God in the app is represented by this model. All user-facing text
// is stored in [LocalizedText] so the UI can switch between Hindi, Nepali,
// and English seamlessly.

/// Tri-language text holder.
///
/// Usage:
/// ```dart
/// final name = god.name.forLang('ne'); // Nepali name
/// ```
class LocalizedText {
  final String hi; // Hindi (primary)
  final String ne; // Nepali
  final String en; // English

  const LocalizedText({
    required this.hi,
    required this.ne,
    required this.en,
  });

  /// Returns the text for the given language code.
  /// Falls back to Hindi if the language is unknown.
  String forLang(String lang) {
    switch (lang) {
      case 'ne':
        return ne;
      case 'en':
        return en;
      case 'hi':
      default:
        return hi;
    }
  }

  @override
  String toString() => hi; // Default display is Hindi
}

/// Represents a Hindu deity in the app.
///
/// Each God has:
/// - Unique [id] matching the keys used in [StorageService] (e.g. 'hanuman')
/// - Tri-language [name], [shortDescription], [mantra], [mantraMeaning]
/// - [imagePath] pointing to the asset image
class GodModel {
  /// Unique identifier (e.g. 'hanuman', 'shiva', 'ganesha')
  final String id;

  /// Display name in 3 languages
  final LocalizedText name;

  /// Path to the God's image asset
  final String imagePath;

  /// A brief 1-2 line description of the deity
  final LocalizedText shortDescription;

  /// The primary mantra text associated with this God
  final LocalizedText mantra;

  /// Meaning / translation of the mantra
  final LocalizedText mantraMeaning;

  /// Color hex for subtle theming (e.g. saffron for Hanuman, blue for Shiva)
  final int themeColorHex;

  const GodModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.shortDescription,
    required this.mantra,
    required this.mantraMeaning,
    this.themeColorHex = 0xFFE67E22, // Default saffron
  });

  /// Convenience getters for direct access
  String get nameHindi => name.hi;
  String get nameNepali => name.ne;
  String get nameEnglish => name.en;

  String get shortDescriptionHindi => shortDescription.hi;
  String get shortDescriptionNepali => shortDescription.ne;
  String get shortDescriptionEnglish => shortDescription.en;

  String get mantraHindi => mantra.hi;
  String get mantraNepali => mantra.ne;
  String get mantraEnglish => mantra.en;

  String get mantraMeaningHindi => mantraMeaning.hi;
  String get mantraMeaningNepali => mantraMeaning.ne;
  String get mantraMeaningEnglish => mantraMeaning.en;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GodModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GodModel($id)';
}
