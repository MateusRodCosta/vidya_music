import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidya_music/controller/services/shared_preferences_singleton.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({bool edgeToEdgeEnabled = false}) {
    _init();
    _isEdgeToEdgeEnabled = edgeToEdgeEnabled;
  }

  late final SharedPreferences _prefs;

  static const themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool _isEdgeToEdgeEnabled = false;
  bool get isEdgeToEdgeEnabled => _isEdgeToEdgeEnabled;

  Future<void> _init() async {
    _prefs = await SharedPreferencesSingleton.instance;
    _loadSettings();
  }

  void _loadSettings() {
    _themeMode = _getThemeMode();
    notifyListeners();
  }

  ThemeMode _getThemeMode() {
    final value = _prefs.getString(themeKey);

    if (value == null || value.isEmpty) return ThemeMode.system;
    return ThemeMode.values.byName(value);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (await _prefs.setString(themeKey, themeMode.name)) {
      _themeMode = themeMode;
      notifyListeners();
    }
  }
}
