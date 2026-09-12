// ══════════════════════════════════════════════════════════════════════════════
// AARTI ITEM MODEL — Clean data entity for "Aaj ki Aarti"
// ══════════════════════════════════════════════════════════════════════════════
//
// Represents an Aarti or Chalisa item with its matched audio file, lyrics file,
// deity linkage, weekday & festival priority metadata, and multi-language support.

import 'god_model.dart';
import 'aarti_model.dart';

/// Reason why this Aarti was selected for the day.
enum AartiSelectionReason {
  /// Major Hindu festival or auspicious occasion today
  festival,

  /// Traditional weekday association (e.g. Monday = Shiva, Tuesday = Hanuman)
  weekday,

  /// User's preferred deity selected during onboarding
  userPreference,

  /// Default fallback (universal Hanuman Chalisa or Shiv Aarti)
  fallback,
}

/// Model representing an Aarti item with full audio and lyrics pairing.
class AartiItem {
  /// Unique identifier (e.g. 'hanuman_chalisa', 'om_jai_shiv_omkara')
  final String id;

  /// Tri-language title (Hindi primary, Nepali, English)
  final LocalizedText title;

  /// Tri-language subtitle / description
  final LocalizedText subtitle;

  /// Related God ID (e.g. 'hanuman', 'shiva', 'ganesha', 'krishna', 'ram', 'durga')
  final String relatedGodId;

  /// Tri-language deity name for display
  final LocalizedText godName;

  /// Asset path to the audio file inside assets/audio/aarti/
  final String audioPath;

  /// Asset path to the matching .txt lyrics file
  final String lyricsPath;

  /// Asset path to the deity's image
  final String imagePath;

  /// Days of the week traditionally associated with this Aarti (1=Mon ... 7=Sun)
  final List<int> days;

  /// Festival IDs that trigger this Aarti
  final List<String> festivalIds;

  /// Whether this is a default fallback Aarti
  final bool isDefault;

  /// Estimated duration of the Aarti recitation
  final Duration duration;

  /// Raw lyrics text loaded from the matching .txt file
  final String? rawLyrics;

  /// Structured verses if available (for backwards compatibility)
  final List<AartiVerse> verses;

  /// Why this Aarti was selected for today
  final AartiSelectionReason selectionReason;

  /// Senior-friendly selection badge (e.g. "मंगलवार विशेष • श्री हनुमान जी")
  final LocalizedText selectionBadge;

  const AartiItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.relatedGodId,
    required this.godName,
    required this.audioPath,
    required this.lyricsPath,
    required this.imagePath,
    this.days = const [],
    this.festivalIds = const [],
    this.isDefault = false,
    this.duration = const Duration(minutes: 4, seconds: 30),
    this.rawLyrics,
    this.verses = const [],
    this.selectionReason = AartiSelectionReason.fallback,
    this.selectionBadge = const LocalizedText(
      hi: 'दैनिक आरती • पावन स्मरण',
      ne: 'दैनिक आरती • पावन स्मरण',
      en: 'Daily Aarti • Sacred Remembrance',
    ),
  });

  /// Creates a copy of this AartiItem with updated fields (e.g., after loading rawLyrics).
  AartiItem copyWith({
    String? id,
    LocalizedText? title,
    LocalizedText? subtitle,
    String? relatedGodId,
    LocalizedText? godName,
    String? audioPath,
    String? lyricsPath,
    String? imagePath,
    List<int>? days,
    List<String>? festivalIds,
    bool? isDefault,
    Duration? duration,
    String? rawLyrics,
    List<AartiVerse>? verses,
    AartiSelectionReason? selectionReason,
    LocalizedText? selectionBadge,
  }) {
    return AartiItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      relatedGodId: relatedGodId ?? this.relatedGodId,
      godName: godName ?? this.godName,
      audioPath: audioPath ?? this.audioPath,
      lyricsPath: lyricsPath ?? this.lyricsPath,
      imagePath: imagePath ?? this.imagePath,
      days: days ?? this.days,
      festivalIds: festivalIds ?? this.festivalIds,
      isDefault: isDefault ?? this.isDefault,
      duration: duration ?? this.duration,
      rawLyrics: rawLyrics ?? this.rawLyrics,
      verses: verses ?? this.verses,
      selectionReason: selectionReason ?? this.selectionReason,
      selectionBadge: selectionBadge ?? this.selectionBadge,
    );
  }

  /// Converts an existing AartiModel into an AartiItem
  factory AartiItem.fromAartiModel(
    AartiModel model, {
    required String lyricsPath,
    LocalizedText? godName,
    AartiSelectionReason selectionReason = AartiSelectionReason.fallback,
    LocalizedText? selectionBadge,
    String? rawLyrics,
  }) {
    return AartiItem(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      relatedGodId: model.relatedGodId,
      godName: godName ?? model.title,
      audioPath: model.audioPath,
      lyricsPath: lyricsPath,
      imagePath: model.imagePath,
      days: model.days,
      festivalIds: model.festivalIds,
      isDefault: model.isDefault,
      duration: model.duration,
      rawLyrics: rawLyrics,
      verses: model.verses,
      selectionReason: selectionReason,
      selectionBadge: selectionBadge ??
          LocalizedText(
            hi: 'पावन आरती • ${model.title.hi}',
            ne: 'पावन आरती • ${model.title.ne}',
            en: 'Sacred Aarti • ${model.title.en}',
          ),
    );
  }

  /// Converts this AartiItem to an AartiModel for backward compatibility
  AartiModel toAartiModel() {
    return AartiModel(
      id: id,
      title: title,
      subtitle: subtitle,
      audioPath: audioPath,
      duration: duration,
      imagePath: imagePath,
      verses: verses,
      relatedGodId: relatedGodId,
      days: days,
      festivalIds: festivalIds,
      isDefault: isDefault,
      timeCategory: const LocalizedText(
        hi: 'प्रातः आरती',
        ne: 'प्रातः आरती',
        en: 'Morning Aarti',
      ),
      mood: const LocalizedText(
        hi: 'भक्ति रस',
        ne: 'भक्ति रस',
        en: 'Devotion',
      ),
    );
  }

  /// Gets title for the given language code ('hi', 'ne', 'en')
  String getTitle(String lang) => title.forLang(lang);

  /// Gets subtitle for the given language code ('hi', 'ne', 'en')
  String getSubtitle(String lang) => subtitle.forLang(lang);

  /// Gets selection badge for the given language code
  String getBadge(String lang) => selectionBadge.forLang(lang);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AartiItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AartiItem(id: $id, deity: $relatedGodId, audio: $audioPath)';
}
