import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/config/branding.dart';
import 'package:vidya_music/core/theme/app_theme.dart';
import 'package:vidya_music/core/utils/extensions/build_context_l10n_ext.dart';
import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/presentation/bloc/playlist_cubit.dart';
import 'package:vidya_music/features/settings/presentation/pages/settings_page.dart';

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
                final (
                  Playlist? currentPlaylist,
                  List<Playlist>? availablePlaylists,
                ) = switch (state) {
                  PlaylistStateDecoded s => (null, s.availablePlaylists),
                  PlaylistStateLoading s => (
                    s.selectedPlaylist,
                    s.availablePlaylists,
                  ),
                  PlaylistStateSuccess s => (
                    s.selectedPlaylist,
                    s.availablePlaylists,
                  ),
                  PlaylistStateError s => (null, s.availablePlaylists),
                  _ => (null, null),
                };

                return SafeArea(
                  top: false,
                  bottom: false,
                  left: false,
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    children: [
                      if (availablePlaylists != null)
                        ...availablePlaylists.map(
                          (p) => _buildPlaylistTile(
                            context,
                            p,
                            p == currentPlaylist,
                          ),
                        ),
                      _buildDivider(context),
                      _buildSettingsTile(context),
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
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
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
      shape: listTileShape,
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
      shape: listTileShape,
      leading: const Icon(Icons.settings_outlined),
      title: Text(context.l10n.drawerSettingsTile),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
      ),
    );
  }
}
