import 'package:flutter/foundation.dart';
import '../models/panchang.dart';
import '../services/panchang_service.dart';

/// Supplies simplified, accurate Panchang data for senior users.
/// Integrates [PanchangService] with Kathmandu default and Delhi option.
class PanchangProvider extends ChangeNotifier {
  PanchangData _data = PanchangData.defaultToday;
  String _currentCity = PanchangService.defaultCityName;
  String _currentLang = 'hi';

  PanchangData get data => _data;
  String get currentCity => _currentCity;
  String get currentLang => _currentLang;

  PanchangProvider({String? initialCity, String? initialLang}) {
    if (initialCity != null) _currentCity = initialCity;
    if (initialLang != null) _currentLang = initialLang;
  }

  /// Refreshes panchang using PanchangService for current city and language
  void refresh({String? city, String? lang}) {
    if (city != null) _currentCity = city;
    if (lang != null) _currentLang = lang;

    final newPanchang = PanchangService.getPanchang(
      city: _currentCity,
      lang: _currentLang,
    );
    _data = PanchangData.fromNew(newPanchang);
    notifyListeners();
  }

  /// Switch calculation city (e.g. 'Kathmandu', 'Delhi')
  void setCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      refresh();
    }
  }

  /// Sync language change from SettingsProvider
  void setLanguage(String lang) {
    if (_currentLang != lang) {
      _currentLang = lang;
      refresh();
    }
  }

  /// Direct update helper
  void updatePanchang(PanchangData newData) {
    _data = newData;
    notifyListeners();
  }
}
