import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/cubit/theme_cubit.dart';
import 'package:vidya_music/theme/color_schemes.g.dart';
import 'package:vidya_music/utils/utils.dart';
import 'package:vidya_music/view/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId:
        'com.mateusrodcosta.apps.vidyamusic.channel.audio',
    androidNotificationChannelName: 'Vidya Music Audio playback',
    androidNotificationChannelDescription:
        'Vidya Music Audio playback controls',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'drawable/ic_player_notification',
  );

  final enableEdgeToEdge = await supportsEdgeToEdge();

  if (enableEdgeToEdge) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(
    Provider<bool>.value(
      value: enableEdgeToEdge,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PlaylistCubit()),
          BlocProvider(create: (context) => AudioPlayerCubit()),
          BlocProvider(create: (context) => ThemeCubit()),
        ],
        child: EasyLocalization(
          supportedLocales: const [
            Locale('en'),
            Locale('pt', 'BR'),
          ],
          path: 'assets/i18n',
          fallbackLocale: const Locale('en'),
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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Vidya Music',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          themeMode: state.themeMode,
          home: const MainPage(title: 'Vidya Music'),
        );
      },
    );
  }
}
