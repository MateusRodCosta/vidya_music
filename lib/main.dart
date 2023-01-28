import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/roster_cubit.dart';
import 'package:vidya_music/theme/color_schemes.g.dart';

import 'package:vidya_music/view/player.dart';
import 'package:vidya_music/view/roster_list.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId:
        'com.mateusrodcosta.apps.vidyamusic.channel.audio',
    androidNotificationChannelName: 'Vidya Music Audio playback',
    androidNotificationChannelDescription:
        'Vidya Music Audio playback controls',
    androidNotificationOngoing: true,
    androidNotificationIcon: "drawable/ic_launcher_foreground",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RosterCubit()),
        BlocProvider(create: (context) => AudioPlayerCubit()),
      ],
      child: MaterialApp(
        title: 'Vidya Music',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const MyHomePage(title: 'Vidya Music'),
      ),
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
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationName: "Vydia Music",
                    applicationVersion: "0.0.1",
                    applicationLegalese:
                        "Licensed under AGPLv3+, developed by MateusRodCosta",
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                          'A player for the Vidya Intarweb Playlist (aka VIP Aersia)'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        child: Text('Vidya Intarweb Playlist by Cats777',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                        onTap: () {
                          launchUrl(Uri.parse('https://www.vipvgm.net/'),
                              mode: LaunchMode.externalApplication);
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text('All Tracks © & ℗ Their Respective Owners'),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Source code is available at ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  'https://github.com/MateusRodCosta/vidya_music',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                      Uri.parse(
                                          'https://github.com/MateusRodCosta/vidya_music'),
                                      mode: LaunchMode.externalApplication);
                                },
                            ),
                          ],
                        ),
                      ),
                    ]);
              },
              icon: const Icon(Icons.help_outline))
        ],
      ),
      body: Column(
        children: const [
          Player(),
          Expanded(child: RosterList()),
        ],
      ),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
