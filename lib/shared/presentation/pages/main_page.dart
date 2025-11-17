import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/core/utils/measurements.dart';
import 'package:vidya_music/features/audio_player/presentation/widgets/miniplayer.dart';
import 'package:vidya_music/features/playlist/presentation/bloc/playlist_cubit.dart';
import 'package:vidya_music/features/playlist/presentation/widgets/roster_list.dart';
import 'package:vidya_music/shared/presentation/widgets/app_drawer.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width >= largeScreenBreakpoint;

    final body = _buildBody(isLargeScreen: isLarge);

    return Scaffold(
      endDrawer: !isLarge ? const AppDrawer() : null,
      body: isLarge
          ? Row(
              children: [
                body,
                AppDrawer(isLargeScreen: isLarge),
              ],
            )
          : body,
    );
  }

  Widget _buildBody({bool isLargeScreen = false}) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              _buildAppBar(isLargeScreen: isLargeScreen),
              const Expanded(child: RosterList()),
            ],
          ),
          const Positioned.fill(
            top: null,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar({bool isLargeScreen = false}) {
    return AppBar(
      title: BlocSelector<PlaylistCubit, PlaylistState, String?>(
        selector: (state) => switch (state) {
          final PlaylistStateLoading s => s.selectedPlaylist.name,
          final PlaylistStateSuccess s => s.selectedPlaylist.name,
          _ => null,
        },
        builder: (context, playlistName) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: !isLargeScreen
                ? () => Scaffold.of(context).openEndDrawer()
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$title${playlistName != null ? ' - $playlistName' : ''}',
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
