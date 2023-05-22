import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'controller/cubit/audio_player_cubit.dart';
import 'controller/cubit/playlist_cubit.dart';
import 'controller/cubit/theme_cubit.dart';
import 'theme/color_schemes.g.dart';
import 'utils/utils.dart';
import 'view/pages/main_page.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId:
        'com.mateusrodcosta.apps.vidyamusic.channel.audio',
    androidNotificationChannelName: 'Vidya Music Audio playback',
    androidNotificationChannelDescription:
        'Vidya Music Audio playback controls',
    androidNotificationOngoing: true,
    androidNotificationIcon: "drawable/ic_player_notification",
  );

  final enableEdgeToEdge = await supportsEdgeToEdge();

  if (enableEdgeToEdge) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(
    Provider<bool>.value(
      value: enableEdgeToEdge,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlaylistCubit()),
        BlocProvider(create: (context) => AudioPlayerCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
        return MaterialApp(
          title: 'Vidya Music',
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          themeMode: state.themeMode,
          home: const MainPage(title: 'Vidya Music'),
        );
      }),
    );
  }
}
