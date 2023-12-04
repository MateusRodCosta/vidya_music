import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

List<String> get appSupportedLocalesAsString => const ['en', 'pt_BR'];
List<Locale> get appSupportedLocales =>
    appSupportedLocalesAsString.map((s) => s.toLocale()).toList();
Locale get appDefaultLocale => appSupportedLocales.first;
