import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/cubit/theme_cubit.dart';
import 'package:vidya_music/theme/color_schemes.g.dart';
import 'package:vidya_music/view/app_drawer.dart';

import 'package:vidya_music/view/player.dart';
import 'package:vidya_music/view/roster_list.dart';

import 'model/playlist.dart';

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
  runApp(const MyApp());
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
          home: const MyHomePage(title: 'Vidya Music'),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
      ),
      endDrawer: const AppDrawer(),
      body: const Column(
        children: [
          Player(),
          Expanded(child: RosterList()),
        ],
      ),
    );
  }

  BlocBuilder<PlaylistCubit, PlaylistState> _buildTitle() {
    Playlist? currentPlaylist;

    return BlocBuilder<PlaylistCubit, PlaylistState>(builder: (context, rs) {
      if (rs is PlaylistStateLoading) {
        currentPlaylist = rs.selectedRoster;
      }
      if (rs is PlaylistStateSuccess) {
        currentPlaylist = rs.selectedRoster;
      }
      return InkWell(
        onTap: () {
          Scaffold.of(context).openEndDrawer();
        },
        child: Text(
            '${widget.title}${currentPlaylist != null ? ' - ${currentPlaylist!.name}' : ''}'),
      );
    });
  }
}
