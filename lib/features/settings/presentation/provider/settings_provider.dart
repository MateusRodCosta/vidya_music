import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidya_music/core/singletons/shared_preferences_singleton.dart';
import 'package:vidya_music/core/utils/theme_mode_ext.dart';
import 'package:vidya_music/core/utils/utils.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _init();
  }

  late final SharedPreferences _prefs;

  static const themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> _init() async {
    _prefs = await SharedPreferencesSingleton.instance;
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    _themeMode = _getThemeMode();
    await _setupSysUi(_themeMode);
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
      await _setupSysUi(themeMode);
      notifyListeners();
    }
  }

  Future<void> _setupSysUi(ThemeMode themeMode) async {
    if (await isAndroidQOrHigher) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: themeMode.sysUiIconBrightness,
        ),
      );
    }
  }
}
