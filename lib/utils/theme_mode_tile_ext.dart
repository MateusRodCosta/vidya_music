import 'package:flutter/material.dart';

extension ThemeModeTileExt on ThemeMode {
  String get tileLabelString {
    switch (this) {
      case ThemeMode.system:
        return 'theme_mode_system';
      case ThemeMode.light:
        return 'theme_mode_light';
      case ThemeMode.dark:
        return 'theme_mode_dark';
    }
  }

  IconData get tileIcon {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}
