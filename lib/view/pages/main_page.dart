import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/view/widgets/app_drawer.dart';
import 'package:vidya_music/view/widgets/player/player.dart';
import 'package:vidya_music/view/widgets/roster_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width >= 840;

    final body = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            _buildAppBar(isLargeScreen: isLarge),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).padding.bottom + playerMinHeight,
                ),
                child: const RosterList(),
              ),
            ),
          ],
        ),
        const AppMiniPlayer(),
      ],
    );

    return Scaffold(
      endDrawer: !isLarge ? const AppDrawer() : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLarge
          ? Row(
              children: [
                Expanded(child: body),
                AppDrawer(isLargeScreen: isLarge),
              ],
            )
          : body,
    );
  }

  AppBar _buildAppBar({bool isLargeScreen = false}) {
    Playlist? currentPlaylist;

    return AppBar(
      title: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, rs) {
          if (rs is PlaylistStateLoading) {
            currentPlaylist = rs.selectedPlaylist;
          }
          if (rs is PlaylistStateSuccess) {
            currentPlaylist = rs.selectedPlaylist;
          }
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: !isLargeScreen
                ? () => Scaffold.of(context).openEndDrawer()
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title +
                      (currentPlaylist != null
                          ? ' - ${currentPlaylist!.name}'
                          : ''),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          );
        },
      ),
    );
  }
}
