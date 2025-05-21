import 'package:flutter/material.dart' show IconData, Icons, ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:vidya_music/utils/l10n_ext.dart';

extension ThemeModeTileExt on ThemeMode {
  String tileLabelKey(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return context.l10n.themeModeSystem;
      case ThemeMode.light:
        return context.l10n.themeModeLight;
      case ThemeMode.dark:
        return context.l10n.themeModeDark;
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
