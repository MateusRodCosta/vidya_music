import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/core/theme/app_theme.dart';
import 'package:vidya_music/core/utils/branding.dart';
import 'package:vidya_music/core/utils/utils.dart';
import 'package:vidya_music/features/audio_player/data/datasources/audio_player_service.dart';
import 'package:vidya_music/features/audio_player/presentation/bloc/audio_player_cubit.dart';
import 'package:vidya_music/features/playlist/data/repositories/config_repostiory_impl.dart';
import 'package:vidya_music/features/playlist/data/repositories/roster_repostiory_impl.dart';
import 'package:vidya_music/features/playlist/domain/repositories/config_repository.dart';
import 'package:vidya_music/features/playlist/domain/repositories/roster_repository.dart';
import 'package:vidya_music/features/playlist/domain/usecases/get_config_and_load_roster_usecase.dart';
import 'package:vidya_music/features/playlist/domain/usecases/load_roster_usecase.dart';
import 'package:vidya_music/features/playlist/presentation/bloc/playlist_cubit.dart';
import 'package:vidya_music/features/settings/presentation/provider/settings_provider.dart';
import 'package:vidya_music/shared/presentation/pages/main_page.dart';
import 'package:vidya_music/src/generated/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await JustAudioBackground.init(
      androidNotificationChannelId: justAudioNotificationChannelId,
      androidNotificationChannelName: justAudioNotificationChannelName,
      androidNotificationChannelDescription:
          justAudioNotificationChannelDescription,
      androidNotificationOngoing: true,
      androidNotificationIcon: justAudioNotificationIcon,
    );
  }

  final isAndroidQ = await isAndroidQOrHigher;
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: isAndroidQ ? Colors.transparent : Colors.black,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConfigRepository>(
          create: (context) => ConfigRepositoryImpl(),
        ),
        RepositoryProvider<RosterRepository>(
          create: (context) => RosterRepositoryImpl(),
        ),
        RepositoryProvider<AudioPlayerService>(
          create: (context) => AudioPlayerService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PlaylistCubit(
              GetConfigAndLoadRosterUseCase(
                context.read<ConfigRepository>(),
                context.read<RosterRepository>(),
              ),
              LoadRosterUseCase(
                context.read<RosterRepository>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AudioPlayerCubit(
              audioPlayerService: context.read<AudioPlayerService>(),
              playlistCubit: context.read<PlaylistCubit>(),
            ),
          ),
        ],
        child: ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
          child: MyApp(isAndroidQ: isAndroidQ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isAndroidQ = false});

  final bool isAndroidQ;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode =
        settingsProvider.themeMode == ThemeMode.dark ||
        (settingsProvider.themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);

    final overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: isAndroidQ
          ? Colors.transparent
          : (isDarkMode ? Colors.black : Colors.white),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDarkMode
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: appName,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: settingsProvider.themeMode,
        home: const MainPage(title: appName),
      ),
    );
  }
}
