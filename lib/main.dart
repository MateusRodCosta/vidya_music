import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/cubit/theme_cubit.dart';
import 'package:vidya_music/theme/color_schemes.g.dart';

import 'package:vidya_music/view/player.dart';
import 'package:vidya_music/view/roster_dropdown.dart';
import 'package:vidya_music/view/roster_list.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  late String appName;
  late String appVersion;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('${widget.title} - '),
            const RosterDropdown(),
            BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
              return DropdownButton<ThemeMode>(
                  value: BlocProvider.of<ThemeCubit>(context).state.themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (tm) {
                    BlocProvider.of<ThemeCubit>(context, listen: false)
                        .setThemeMode(tm ?? ThemeMode.system);
                  });
            }),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showAboutDialog(
                    context: context,
                    applicationName: appName,
                    applicationVersion: appVersion,
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
      body: const Column(
        children: [
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
