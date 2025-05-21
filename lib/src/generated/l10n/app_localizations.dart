import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @currentPlaylist.
  ///
  /// In en_US, this message translates to:
  /// **'Current Playlist'**
  String get currentPlaylist;

  /// No description provided for @playlistConfigDecodingError.
  ///
  /// In en_US, this message translates to:
  /// **'Error decoding playlist config'**
  String get playlistConfigDecodingError;

  /// No description provided for @genericError.
  ///
  /// In en_US, this message translates to:
  /// **'An Error Occurred.'**
  String get genericError;

  /// No description provided for @rosterErrorNoInternet.
  ///
  /// In en_US, this message translates to:
  /// **'No Internet Connection!'**
  String get rosterErrorNoInternet;

  /// No description provided for @rosterErrorCouldntFetch.
  ///
  /// In en_US, this message translates to:
  /// **'Couldn\'t fetch tracks...'**
  String get rosterErrorCouldntFetch;

  /// No description provided for @rosterRetry.
  ///
  /// In en_US, this message translates to:
  /// **'Retry'**
  String get rosterRetry;

  /// No description provided for @playerNoTrack.
  ///
  /// In en_US, this message translates to:
  /// **'No track'**
  String get playerNoTrack;

  /// No description provided for @playerArranger.
  ///
  /// In en_US, this message translates to:
  /// **'{arranger} (Arranger)'**
  String playerArranger(Object arranger);

  /// No description provided for @playerComposer.
  ///
  /// In en_US, this message translates to:
  /// **'{composer} (Composer)'**
  String playerComposer(Object composer);

  /// No description provided for @themeModeHeader.
  ///
  /// In en_US, this message translates to:
  /// **'Theme'**
  String get themeModeHeader;

  /// No description provided for @themeModeSystem.
  ///
  /// In en_US, this message translates to:
  /// **'System Theme'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en_US, this message translates to:
  /// **'Light Theme'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en_US, this message translates to:
  /// **'Dark Theme'**
  String get themeModeDark;

  /// No description provided for @drawerSettingsTile.
  ///
  /// In en_US, this message translates to:
  /// **'Settings'**
  String get drawerSettingsTile;

  /// No description provided for @drawerAboutTile.
  ///
  /// In en_US, this message translates to:
  /// **'About'**
  String get drawerAboutTile;

  /// No description provided for @aboutDialogLicense.
  ///
  /// In en_US, this message translates to:
  /// **'Licensed under AGPLv3+, developed by MateusRodCosta'**
  String get aboutDialogLicense;

  /// No description provided for @aboutDialogAppDescription.
  ///
  /// In en_US, this message translates to:
  /// **'A player for the Vidya Intarweb Playlist (aka VIP Aersia)'**
  String get aboutDialogAppDescription;

  /// No description provided for @aboutDialogVipCats777.
  ///
  /// In en_US, this message translates to:
  /// **'Vidya Intarweb Playlist by Cats777'**
  String get aboutDialogVipCats777;

  /// No description provided for @aboutDialogCopyrightNotice.
  ///
  /// In en_US, this message translates to:
  /// **'All Tracks © & ℗ Their Respective Owners'**
  String get aboutDialogCopyrightNotice;

  /// No description provided for @aboutDialogSourceCode.
  ///
  /// In en_US, this message translates to:
  /// **'Source code is available at '**
  String get aboutDialogSourceCode;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en_US, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsAppearanceHeader.
  ///
  /// In en_US, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceHeader;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en': {
  switch (locale.countryCode) {
    case 'US': return AppLocalizationsEnUs();
   }
  break;
   }
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
