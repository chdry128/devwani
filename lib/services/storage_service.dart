import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Offline Local Storage Service using SharedPreferences with graceful in-memory fallback
class StorageService {
  static const String _keyCurrentCount = 'devavani_jaap_count';
  static const String _keyDailyTotal = 'devavani_jaap_daily_total';
  static const String _keyMalasCompleted = 'devavani_jaap_malas';
  static const String _keySelectedMantraId = 'devavani_selected_mantra';
  static const String _keyVibration = 'devavani_vibration_enabled';
  static const String _keySound = 'devavani_sound_enabled';
  static const String _keyFontStage = 'devavani_font_stage';
  static const String _keyLanguage = 'devavani_language';
  static const String _keyLastJaapDate = 'devavani_last_jaap_date';
  static const String _keySelectedDeities = 'devavani_selected_deities';
  static const String _keyOnboardingDone = 'devavani_onboarding_done';
  static const String _keyMorningReminderEnabled = 'devavani_morning_reminder_enabled';
  static const String _keyMorningReminderHour = 'devavani_morning_reminder_hour';
  static const String _keyMorningReminderMinute = 'devavani_morning_reminder_minute';
  static const String _keyEveningReminderEnabled = 'devavani_evening_reminder_enabled';
  static const String _keyEveningReminderHour = 'devavani_evening_reminder_hour';
  static const String _keyEveningReminderMinute = 'devavani_evening_reminder_minute';

  final SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryCache = {};

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return StorageService(prefs);
    } catch (e) {
      debugPrint('StorageService: SharedPreferences init failed ($e), using in-memory fallback');
      return StorageService(null);
    }
  }

  // --- Jaap State ---
  int getJaapCount() =>
      _prefs?.getInt(_keyCurrentCount) ??
      (_memoryCache[_keyCurrentCount] as int?) ??
      0;

  Future<bool> saveJaapCount(int count) async {
    _memoryCache[_keyCurrentCount] = count;
    return (await _prefs?.setInt(_keyCurrentCount, count)) ?? true;
  }

  int getDailyTotal() {
    final savedDate =
        _prefs?.getString(_keyLastJaapDate) ??
        (_memoryCache[_keyLastJaapDate] as String?);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (savedDate != today) {
      return 0;
    }
    return _prefs?.getInt(_keyDailyTotal) ??
        (_memoryCache[_keyDailyTotal] as int?) ??
        0;
  }

  Future<void> saveDailyTotal(int total) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _memoryCache[_keyLastJaapDate] = today;
    _memoryCache[_keyDailyTotal] = total;
    await _prefs?.setString(_keyLastJaapDate, today);
    await _prefs?.setInt(_keyDailyTotal, total);
  }

  int getMalasCompleted() =>
      _prefs?.getInt(_keyMalasCompleted) ??
      (_memoryCache[_keyMalasCompleted] as int?) ??
      0;

  Future<bool> saveMalasCompleted(int malas) async {
    _memoryCache[_keyMalasCompleted] = malas;
    return (await _prefs?.setInt(_keyMalasCompleted, malas)) ?? true;
  }

  String getSelectedMantraId() =>
      _prefs?.getString(_keySelectedMantraId) ??
      (_memoryCache[_keySelectedMantraId] as String?) ??
      'ram';

  Future<bool> saveSelectedMantraId(String id) async {
    _memoryCache[_keySelectedMantraId] = id;
    return (await _prefs?.setString(_keySelectedMantraId, id)) ?? true;
  }

  bool getVibrationEnabled() =>
      _prefs?.getBool(_keyVibration) ??
      (_memoryCache[_keyVibration] as bool?) ??
      true;

  Future<bool> saveVibrationEnabled(bool enabled) async {
    _memoryCache[_keyVibration] = enabled;
    return (await _prefs?.setBool(_keyVibration, enabled)) ?? true;
  }

  bool getSoundEnabled() =>
      _prefs?.getBool(_keySound) ??
      (_memoryCache[_keySound] as bool?) ??
      true;

  Future<bool> saveSoundEnabled(bool enabled) async {
    _memoryCache[_keySound] = enabled;
    return (await _prefs?.setBool(_keySound, enabled)) ?? true;
  }

  // --- Settings State ---
  int getFontStage() =>
      _prefs?.getInt(_keyFontStage) ??
      (_memoryCache[_keyFontStage] as int?) ??
      1; // 0: Normal, 1: Large (+25%), 2: Extra Large

  Future<bool> saveFontStage(int stage) async {
    _memoryCache[_keyFontStage] = stage;
    return (await _prefs?.setInt(_keyFontStage, stage)) ?? true;
  }

  String getLanguage() =>
      _prefs?.getString(_keyLanguage) ??
      (_memoryCache[_keyLanguage] as String?) ??
      'hi';

  Future<bool> saveLanguage(String lang) async {
    _memoryCache[_keyLanguage] = lang;
    return (await _prefs?.setString(_keyLanguage, lang)) ?? true;
  }

  // --- Deity Preference (Onboarding) ---

  /// Returns list of selected deity IDs (e.g. ['hanuman', 'ganesha']).
  List<String> getSelectedDeities() {
    final raw = _prefs?.getStringList(_keySelectedDeities) ??
        (_memoryCache[_keySelectedDeities] as List<String>?);
    return raw ?? [];
  }

  Future<bool> saveSelectedDeities(List<String> deities) async {
    _memoryCache[_keySelectedDeities] = deities;
    return (await _prefs?.setStringList(_keySelectedDeities, deities)) ?? true;
  }

  /// Whether the user has completed the deity-selection onboarding.
  bool hasCompletedOnboarding() =>
      _prefs?.getBool(_keyOnboardingDone) ??
      (_memoryCache[_keyOnboardingDone] as bool?) ??
      false;

  Future<bool> setOnboardingComplete() async {
    _memoryCache[_keyOnboardingDone] = true;
    return (await _prefs?.setBool(_keyOnboardingDone, true)) ?? true;
  }

  // --- Daily Reminders State ---
  bool getMorningReminderEnabled() =>
      _prefs?.getBool(_keyMorningReminderEnabled) ??
      (_memoryCache[_keyMorningReminderEnabled] as bool?) ??
      false;

  Future<bool> saveMorningReminderEnabled(bool enabled) async {
    _memoryCache[_keyMorningReminderEnabled] = enabled;
    return (await _prefs?.setBool(_keyMorningReminderEnabled, enabled)) ?? true;
  }

  int getMorningReminderHour() =>
      _prefs?.getInt(_keyMorningReminderHour) ??
      (_memoryCache[_keyMorningReminderHour] as int?) ??
      7; // Default 7:00 AM

  Future<bool> saveMorningReminderHour(int hour) async {
    _memoryCache[_keyMorningReminderHour] = hour;
    return (await _prefs?.setInt(_keyMorningReminderHour, hour)) ?? true;
  }

  int getMorningReminderMinute() =>
      _prefs?.getInt(_keyMorningReminderMinute) ??
      (_memoryCache[_keyMorningReminderMinute] as int?) ??
      0;

  Future<bool> saveMorningReminderMinute(int minute) async {
    _memoryCache[_keyMorningReminderMinute] = minute;
    return (await _prefs?.setInt(_keyMorningReminderMinute, minute)) ?? true;
  }

  bool getEveningReminderEnabled() =>
      _prefs?.getBool(_keyEveningReminderEnabled) ??
      (_memoryCache[_keyEveningReminderEnabled] as bool?) ??
      false;

  Future<bool> saveEveningReminderEnabled(bool enabled) async {
    _memoryCache[_keyEveningReminderEnabled] = enabled;
    return (await _prefs?.setBool(_keyEveningReminderEnabled, enabled)) ?? true;
  }

  int getEveningReminderHour() =>
      _prefs?.getInt(_keyEveningReminderHour) ??
      (_memoryCache[_keyEveningReminderHour] as int?) ??
      19; // Default 7:00 PM (19:00)

  Future<bool> saveEveningReminderHour(int hour) async {
    _memoryCache[_keyEveningReminderHour] = hour;
    return (await _prefs?.setInt(_keyEveningReminderHour, hour)) ?? true;
  }

  int getEveningReminderMinute() =>
      _prefs?.getInt(_keyEveningReminderMinute) ??
      (_memoryCache[_keyEveningReminderMinute] as int?) ??
      0;

  Future<bool> saveEveningReminderMinute(int minute) async {
    _memoryCache[_keyEveningReminderMinute] = minute;
    return (await _prefs?.setInt(_keyEveningReminderMinute, minute)) ?? true;
  }
}
