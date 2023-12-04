import 'package:flutter/material.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';

extension ThemeModeTileExt on ThemeMode {
  String get tileLabelKey {
    switch (this) {
      case ThemeMode.system:
        return LocaleKeys.themeModeSystem;
      case ThemeMode.light:
        return LocaleKeys.themeModeLight;
      case ThemeMode.dark:
        return LocaleKeys.themeModeDark;
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
