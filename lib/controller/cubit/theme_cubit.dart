import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidya_music/controller/services/prefs.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  late SharedPreferences _prefs;
  final String themeKey = "theme_mode";

  Future<void> _initPrefs() async {
    _prefs = await Prefs.instance;
  }

  ThemeMode _valueToThemeMode(String? value) {
    if (value == null) return ThemeMode.system;
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    _initPrefs().then((_) => _initializeThemeMode());
  }

  void _initializeThemeMode() {
    final value = _prefs.getString(themeKey);
    final themeMode = _valueToThemeMode(value);

    emit(ThemeState(themeMode));
  }

  void setThemeMode(ThemeMode themeMode) {
    final value = themeMode.name;
    _prefs.setString(themeKey, value);

    emit(ThemeState(themeMode));
  }
}
