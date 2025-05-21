import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/src/generated/l10n/app_localizations.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/theme/color_schemes.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/utils/l10n_ext.dart';
import 'package:vidya_music/utils/utils.dart';
import 'package:vidya_music/view/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: justAudioNotificationChannelId,
    androidNotificationChannelName: justAudioNotificationChannelName,
    androidNotificationChannelDescription:
        justAudioNotificationChannelDescription,
    androidNotificationOngoing: true,
    androidNotificationIcon: justAudioNotificationIcon,
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (await isAndroidQOrHigher) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        BlocProvider(create: (_) => AudioPlayerCubit()),
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
      home: BlocProvider(
        create: (context) => PlaylistCubit(l10n: context.l10n),
        child: const MainPage(title: appName),
      ),
    );
  }
}
