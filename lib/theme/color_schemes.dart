import 'package:flutter/material.dart';

const seedColor = Color(0xFF1F4B7F);
const tertiaryColor = Color(0xFFFFA366);

ColorScheme get lightColorScheme =>
    ColorScheme.fromSeed(seedColor: seedColor, tertiary: tertiaryColor);

ColorScheme get darkColorScheme => ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      tertiary: tertiaryColor,
    );
