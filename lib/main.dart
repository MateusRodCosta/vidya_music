import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/src/generated/l10n/app_localizations.dart';
import 'package:vidya_music/theme/color_schemes.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/utils/utils.dart';
import 'package:vidya_music/view/pages/main_page.dart';

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
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        BlocProvider(create: (context) => PlaylistCubit()),
        BlocProvider(create: (context) => AudioPlayerCubit()),
      ],
      child: const MyApp(),
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
