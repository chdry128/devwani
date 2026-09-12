// ══════════════════════════════════════════════════════════════════════════════
// USER PREFERENCE MODEL — Consolidated user settings
// ══════════════════════════════════════════════════════════════════════════════
//
// Brings together all user preferences into a single model.
// The actual persistence is handled by [StorageService];
// this model is used by [SettingsProvider] to expose a clean API.

/// Supported app languages
enum AppLanguage {
  hi, // Hindi (primary, default)
  ne, // Nepali
  en, // English
}

/// Extension to convert enum to/from string codes
extension AppLanguageExtension on AppLanguage {
  /// Language code string (e.g. 'hi', 'ne', 'en')
  String get code {
    switch (this) {
      case AppLanguage.hi:
        return 'hi';
      case AppLanguage.ne:
        return 'ne';
      case AppLanguage.en:
        return 'en';
    }
  }

  /// Display name in the language itself
  String get displayName {
    switch (this) {
      case AppLanguage.hi:
        return 'हिन्दी';
      case AppLanguage.ne:
        return 'नेपाली';
      case AppLanguage.en:
        return 'English';
    }
  }

  /// Parse a language code string to enum
  static AppLanguage fromCode(String code) {
    switch (code) {
      case 'ne':
        return AppLanguage.ne;
      case 'en':
        return AppLanguage.en;
      case 'hi':
      default:
        return AppLanguage.hi;
    }
  }
}

/// Font size stages for elderly accessibility.
/// 0 = Normal, 1 = Large (+25%), 2 = Extra Large (+50%)
enum FontStage {
  normal,  // Stage 0
  large,   // Stage 1 (default for seniors)
  extraLarge, // Stage 2
}

extension FontStageExtension on FontStage {
  int get value {
    switch (this) {
      case FontStage.normal:
        return 0;
      case FontStage.large:
        return 1;
      case FontStage.extraLarge:
        return 2;
    }
  }

  /// Scale factor to multiply base font sizes by
  double get scaleFactor {
    switch (this) {
      case FontStage.normal:
        return 1.0;
      case FontStage.large:
        return 1.25;
      case FontStage.extraLarge:
        return 1.5;
    }
  }

  static FontStage fromValue(int value) {
    switch (value) {
      case 0:
        return FontStage.normal;
      case 2:
        return FontStage.extraLarge;
      case 1:
      default:
        return FontStage.large;
    }
  }
}

/// Consolidated user preferences.
///
/// Holds all settings in one place. Max 2 preferred Gods.
class UserPreference {
  /// Up to 2 preferred God IDs chosen during onboarding
  /// (e.g. ['hanuman', 'shiva'])
  final List<String> preferredGodIds;

  /// Selected app language
  final AppLanguage language;

  /// Whether Brahma Muhurta (5 AM) reminder is enabled
  final bool brahmaMuhurtaEnabled;

  /// Current font size stage
  final FontStage fontStage;

  /// Whether haptic vibration is enabled for Jaap
  final bool vibrationEnabled;

  /// Whether temple bell sound is enabled for Jaap
  final bool soundEnabled;

  /// Whether the user has completed onboarding
  final bool onboardingComplete;

  const UserPreference({
    this.preferredGodIds = const [],
    this.language = AppLanguage.hi,
    this.brahmaMuhurtaEnabled = true,
    this.fontStage = FontStage.large, // Default large for seniors
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.onboardingComplete = false,
  });

  /// The primary preferred God ID (first in the list), or null if none set
  String? get primaryGodId =>
      preferredGodIds.isNotEmpty ? preferredGodIds.first : null;

  /// The secondary preferred God ID, or null if fewer than 2
  String? get secondaryGodId =>
      preferredGodIds.length >= 2 ? preferredGodIds[1] : null;

  /// Language code string for use with [LocalizedText.forLang()]
  String get langCode => language.code;

  /// Convenience getters for alternate naming conventions
  List<String> get preferredGods => preferredGodIds;
  bool get brahmaMuhurtaReminder => brahmaMuhurtaEnabled;
  FontStage get fontSize => fontStage;

  /// Creates a copy with updated fields
  UserPreference copyWith({
    List<String>? preferredGodIds,
    AppLanguage? language,
    bool? brahmaMuhurtaEnabled,
    FontStage? fontStage,
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? onboardingComplete,
  }) {
    return UserPreference(
      preferredGodIds: preferredGodIds ?? this.preferredGodIds,
      language: language ?? this.language,
      brahmaMuhurtaEnabled: brahmaMuhurtaEnabled ?? this.brahmaMuhurtaEnabled,
      fontStage: fontStage ?? this.fontStage,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
