import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/generated/codegen_loader.g.dart';
import 'package:vidya_music/theme/color_schemes.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/utils/edge_to_edge.dart';
import 'package:vidya_music/utils/i18n.dart';
import 'package:vidya_music/view/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: justAudioNotificationChannelId,
    androidNotificationChannelName: justAudioNotificationChannelName,
    androidNotificationChannelDescription:
        justAudioNotificationChannelDescription,
    androidNotificationOngoing: true,
    androidNotificationIcon: justAudiopNotificationIcon,
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
    MultiProvider(
      providers: [
        Provider<IsEdgeToEdge>.value(value: enableEdgeToEdge),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        BlocProvider(create: (context) => PlaylistCubit()),
        BlocProvider(create: (context) => AudioPlayerCubit()),
      ],
      child: EasyLocalization(
        supportedLocales: appSupportedLocales,
        path: 'assets/i18n',
        fallbackLocale: appDefaultLocale,
        assetLoader: const CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales == null) return;

    for (final l in locales) {
      if (context.supportedLocales.contains(l)) {
        context.setLocale(l);
        return;
      }
      if (context.supportedLocales.contains(Locale(l.languageCode))) {
        context.setLocale(Locale(l.languageCode));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: context.watch<SettingsProvider>().themeMode,
      home: const MainPage(title: appName),
    );
  }
}
