// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> pt_BR = {
  "currentPlaylist": "Playlist Atual",
  "genericError": "Ocorreu um erro.",
  "rosterErrorNoInternet": "Sem Conexão a Internet!",
  "rosterErrorCouldntFetch": "Não foi possível obter as faixas...",
  "rosterRetry": "Tentar novamente",
  "playerNoTrack": "Nenhuma faixa",
  "playerArranger": "{} (Arranjador)",
  "playerComposer": "{} (Compositor)",
  "themeModeHeader": "Tema",
  "themeModeSystem": "Tema do Sistema",
  "themeModeLight": "Tema Claro",
  "themeModeDark": "Tema Escuro",
  "drawerSettingsTile": "Configurações",
  "drawerAboutTile": "Sobre",
  "aboutDialogLicense": "Licenciado sob a AGPLv3+, desenvolvido por MateusRodCosta",
  "aboutDialogAppDescription": "Um player para a Vidya Intarweb Playlist (aka VIP Aersia)",
  "aboutDialogVipCats777": "Vidya Intarweb Playlist por Cats777",
  "aboutDialogCopyrightNotice": "Todas as Faixas Tracks © & ℗ Seus Respectivos Donos",
  "aboutDialogSourceCode": "O código fonte está disponível em ",
  "settingsPageTitle": "Configurações",
  "settingsAppearanceHeader": "Aparência"
};
static const Map<String,dynamic> en_US = {
  "currentPlaylist": "Current Playlist",
  "genericError": "An Error Occurred.",
  "rosterErrorNoInternet": "No Internet Connection!",
  "rosterErrorCouldntFetch": "Couldn't fetch tracks...",
  "rosterRetry": "Retry",
  "playerNoTrack": "No track",
  "playerArranger": "{} (Arranger)",
  "playerComposer": "{} (Composer)",
  "themeModeHeader": "Theme",
  "themeModeSystem": "System Theme",
  "themeModeLight": "Light Theme",
  "themeModeDark": "Dark Theme",
  "drawerSettingsTile": "Settings",
  "drawerAboutTile": "About",
  "aboutDialogLicense": "Licensed under AGPLv3+, developed by MateusRodCosta",
  "aboutDialogAppDescription": "A player for the Vidya Intarweb Playlist (aka VIP Aersia)",
  "aboutDialogVipCats777": "Vidya Intarweb Playlist by Cats777",
  "aboutDialogCopyrightNotice": "All Tracks © & ℗ Their Respective Owners",
  "aboutDialogSourceCode": "Source code is available at ",
  "settingsPageTitle": "Settings",
  "settingsAppearanceHeader": "Appearance"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"pt_BR": pt_BR, "en_US": en_US};
}
