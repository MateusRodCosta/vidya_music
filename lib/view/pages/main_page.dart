import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/view/app_drawer.dart';
import 'package:vidya_music/view/player.dart';
import 'package:vidya_music/view/roster_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width >= 840;

    const bodyContents = [
      Player(),
      Expanded(child: RosterList()),
    ];
    return Scaffold(
      appBar: !isLarge ? _buildAppBar() : null,
      endDrawer: !isLarge ? const AppDrawer() : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLarge
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildAppBar(isLargeScreen: true),
                      ...bodyContents,
                    ],
                  ),
                ),
                AppDrawer(isLargeScreen: isLarge),
              ],
            )
          : const Column(children: bodyContents),
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
