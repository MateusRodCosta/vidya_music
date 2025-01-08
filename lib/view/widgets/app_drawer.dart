import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/services/package_info_singleton.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/view/pages/settings_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.isLargeScreen = false});

  final bool isLargeScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: isLargeScreen ? LinearBorder.none : null,
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(context),
          Expanded(
            child: BlocBuilder<PlaylistCubit, PlaylistState>(
              builder: (context, state) {
                Playlist? currentPlaylist;
                List<Playlist>? availablePlaylists;

                if (state is PlaylistStateDecoded) {
                  availablePlaylists = state.availablePlaylists;
                }
                if (state is PlaylistStateLoading) {
                  currentPlaylist = state.selectedPlaylist;
                  availablePlaylists = state.availablePlaylists;
                }
                if (state is PlaylistStateSuccess) {
                  currentPlaylist = state.selectedPlaylist;
                  availablePlaylists = state.availablePlaylists;
                }
                if (state is PlaylistStateError) {
                  availablePlaylists = state.availablePlaylists;
                }
                return SafeArea(
                  top: false,
                  bottom: false,
                  left: false,
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    children: [
                      if (availablePlaylists != null) ...[
                        ...availablePlaylists.map(
                          (p) => _buildPlaylistTile(
                            context,
                            p,
                            p == currentPlaylist,
                          ),
                        ),
                        _buildDivider(context),
                      ],
                      _buildDivider(context),
                      _buildSettingsTile(context),
                      _buildAboutTile(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      margin: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? appIconPath
                  : appIconMonochromePath,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null,
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0,
      color: Theme.of(context).dividerColor,
      indent: 16,
      endIndent: 16,
    );
  }

  ListTile _buildPlaylistTile(
    BuildContext context,
    Playlist playlist,
    bool isSelected,
  ) {
    return ListTile(
      shape: _getDrawerListTileShape(),
      leading: const Icon(Icons.music_note),
      title: Text(playlist.name),
      subtitle: Text(playlist.description),
      onTap: () async {
        Scaffold.of(context).closeEndDrawer();
        await context.read<PlaylistCubit>().setPlaylist(playlist);
      },
      selected: isSelected,
    );
  }

  ListTile _buildSettingsTile(BuildContext context) {
    return ListTile(
      shape: _getDrawerListTileShape(),
      leading: const Icon(Icons.settings_outlined),
      title: const Text(LocaleKeys.drawerSettingsTile).tr(),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const SettingsPage(),
        ),
      ),
    );
  }

  ListTile _buildAboutTile(BuildContext context) {
    return ListTile(
      shape: _getDrawerListTileShape(),
      leading: const Icon(Icons.help_outline),
      title: const Text(LocaleKeys.drawerAboutTile).tr(),
      onTap: () async {
        final packageInfo = await PackageInfoSingleton.instance;

        // ignore: use_build_context_synchronously
        if (!context.mounted) return;

        showAboutDialog(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationLegalese: LocaleKeys.aboutDialogLicense.tr(),
          children: [
            const SizedBox(height: 8),
            const Text(LocaleKeys.aboutDialogAppDescription).tr(),
            const SizedBox(height: 8),
            GestureDetector(
              child: Text(
                LocaleKeys.aboutDialogVipCats777,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ).tr(),
              onTap: () {
                launchUrl(
                  Uri.parse('https://www.vipvgm.net/'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(LocaleKeys.aboutDialogCopyrightNotice).tr(),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.aboutDialogSourceCode.tr(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  TextSpan(
                    text: 'https://github.com/MateusRodCosta/vidya_music',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse(
                            'https://github.com/MateusRodCosta/vidya_music',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  RoundedRectangleBorder _getDrawerListTileShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    );
  }
}
