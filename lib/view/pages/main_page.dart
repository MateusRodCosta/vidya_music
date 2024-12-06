import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/view/widgets/app_drawer.dart';
import 'package:vidya_music/view/widgets/player/player.dart';
import 'package:vidya_music/view/widgets/roster_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width >= 840;

    final bodyContents = [
      _buildAppBar(isLargeScreen: isLarge),
      const Expanded(
        child: RosterList(),
      ),
    ];

    return Scaffold(
      endDrawer: !isLarge ? const AppDrawer() : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (isLarge)
            Row(
              children: [
                Expanded(
                  child: Column(children: bodyContents),
                ),
                AppDrawer(isLargeScreen: isLarge),
              ],
            )
          else
            Column(children: bodyContents),
          const AppMiniPlayer(),
        ],
      ),
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
