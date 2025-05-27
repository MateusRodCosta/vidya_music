import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/utils/measurements.dart';
import 'package:vidya_music/view/widgets/app_drawer.dart';
import 'package:vidya_music/view/widgets/player/miniplayer.dart';
import 'package:vidya_music/view/widgets/roster_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width >= largeScreenBreakpoint;

    final body = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            _buildAppBar(isLargeScreen: isLarge),
            const Expanded(child: RosterList()),
          ],
        ),
        Positioned.fill(
          top: null,
          bottom: MediaQuery.of(context).padding.bottom,
          child: const MiniPlayer(),
        ),
      ],
    );

    return Scaffold(
      endDrawer: !isLarge ? const AppDrawer() : null,
      body:
          isLarge
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
    return AppBar(
      title: BlocSelector<PlaylistCubit, PlaylistState, String?>(
        selector:
            (state) => switch (state) {
              final PlaylistStateLoading s => s.selectedPlaylist.name,
              final PlaylistStateSuccess s => s.selectedPlaylist.name,
              _ => null,
            },
        builder: (context, currentPlaylistName) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                !isLargeScreen
                    ? () => Scaffold.of(context).openEndDrawer()
                    : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentPlaylistName != null
                      ? '$title - $currentPlaylistName'
                      : title,
                ),
                if (!isLargeScreen) const Icon(Icons.arrow_drop_down),
              ],
            ),
          );
        },
      ),
    );
  }
}
