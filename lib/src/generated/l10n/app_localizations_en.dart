// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs(): super('en_US');

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
