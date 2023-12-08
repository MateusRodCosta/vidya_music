import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

const appSupportedLocalesAsString = ['en', 'pt_BR'];
List<Locale> get appSupportedLocales =>
    appSupportedLocalesAsString.map((s) => s.toLocale()).toList();
Locale get appDefaultLocale => appSupportedLocales.first;
