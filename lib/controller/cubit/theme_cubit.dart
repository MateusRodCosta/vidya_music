import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences_singleton.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    // ignore: discarded_futures
    _initPrefs().then((_) => _initializeThemeMode());
  }

  late SharedPreferences _prefs;
  static const themeKey = 'theme_mode';

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferencesSingleton.instance;
  }

  ThemeMode _valueToThemeMode(String? value) {
    if (value == null) return ThemeMode.system;
    return ThemeMode.values.byName(value);
  }

  void _initializeThemeMode() {
    final value = _prefs.getString(themeKey);
    final themeMode = _valueToThemeMode(value);

    emit(ThemeState(themeMode));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final value = themeMode.name;
    await _prefs.setString(themeKey, value);

    emit(ThemeState(themeMode));
  }
}
