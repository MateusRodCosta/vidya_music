// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get currentPlaylist => 'Current Playlist';

  @override
  String get playlistConfigDecodingError => 'Error decoding playlist config';

  @override
  String get genericError => 'An Error Occurred.';

  @override
  String get rosterErrorNoInternet => 'No Internet Connection!';

  @override
  String get rosterErrorCouldntFetch => 'Couldn\'t fetch tracks...';

  @override
  String get rosterRetry => 'Retry';

  @override
  String get playerNoTrack => 'No track';

  @override
  String playerArranger(Object arranger) {
    return '$arranger (Arranger)';
  }

  @override
  String playerComposer(Object composer) {
    return '$composer (Composer)';
  }

  @override
  String get themeModeHeader => 'Theme';

  @override
  String get themeModeSystem => 'System Theme';

  @override
  String get themeModeLight => 'Light Theme';

  @override
  String get themeModeDark => 'Dark Theme';

  @override
  String get drawerSettingsTile => 'Settings';

  @override
  String get drawerAboutTile => 'About';

  @override
  String get aboutDialogLicense => 'Licensed under AGPLv3+, developed by MateusRodCosta';

  @override
  String get aboutDialogAppDescription => 'A player for the Vidya Intarweb Playlist (aka VIP Aersia)';

  @override
  String get aboutDialogVipCats777 => 'Vidya Intarweb Playlist by Cats777';

  @override
  String get aboutDialogCopyrightNotice => 'All Tracks © & ℗ Their Respective Owners';

  @override
  String get aboutDialogSourceCode => 'Source code is available at ';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsAppearanceHeader => 'Appearance';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get currentPlaylist => 'Playlist Atual';

  @override
  String get playlistConfigDecodingError => 'Erro ao decodificar configuração de playlist';

  @override
  String get genericError => 'Ocorreu um erro.';

  @override
  String get rosterErrorNoInternet => 'Sem Conexão a Internet!';

  @override
  String get rosterErrorCouldntFetch => 'Não foi possível obter as faixas...';

  @override
  String get rosterRetry => 'Tentar novamente';

  @override
  String get playerNoTrack => 'Nenhuma faixa';

  @override
  String playerArranger(Object arranger) {
    return '$arranger (Arranjador)';
  }

  @override
  String playerComposer(Object composer) {
    return '$composer (Compositor)';
  }

  @override
  String get themeModeHeader => 'Tema';

  @override
  String get themeModeSystem => 'Tema do Sistema';

  @override
  String get themeModeLight => 'Tema Claro';

  @override
  String get themeModeDark => 'Tema Escuro';

  @override
  String get drawerSettingsTile => 'Configurações';

  @override
  String get drawerAboutTile => 'Sobre';

  @override
  String get aboutDialogLicense => 'Licenciado sob a AGPLv3+, desenvolvido por MateusRodCosta';

  @override
  String get aboutDialogAppDescription => 'Um player para a Vidya Intarweb Playlist (aka VIP Aersia)';

  @override
  String get aboutDialogVipCats777 => 'Vidya Intarweb Playlist por Cats777';

  @override
  String get aboutDialogCopyrightNotice => 'Todas as Faixas © & ℗ Seus Respectivos Donos';

  @override
  String get aboutDialogSourceCode => 'O código fonte está disponível em ';

  @override
  String get settingsPageTitle => 'Configurações';

  @override
  String get settingsAppearanceHeader => 'Aparência';
}
