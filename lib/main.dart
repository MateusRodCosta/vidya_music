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
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (await isAndroidQOrHigher) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

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
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: appName,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: context.watch<SettingsProvider>().themeMode,
      home: const MainPage(title: appName),
    );
  }
}
