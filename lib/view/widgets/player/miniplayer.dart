import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/utils/build_context_l10n_ext.dart';
import 'package:vidya_music/view/widgets/player/player.dart';
import 'package:vidya_music/view/widgets/player/player_controls.dart';
import 'package:vidya_music/view/widgets/player/player_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<dynamic>(
          context: context,
          builder: (context) => const BigPlayer(),
          isScrollControlled: true,
          constraints: const BoxConstraints.expand(),
        );
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Card.filled(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PlayerProgressBar(isMiniPlayer: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(child: TrackInfo(isMiniPlayer: true)),
                    _buildSimpleControls(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleControls() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerPlayPauseButton(isMiniPlayer: true),
        PlayerNextButton(isMiniPlayer: true),
      ],
    );
  }
}

class BigPlayer extends StatelessWidget {
  const BigPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.secondaryContainer,
      margin: EdgeInsets.zero,
      shape: LinearBorder.none,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          children: [
            _buildBigPlayerTopBar(),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(children: [Spacer(), TrackInfo()]),
                    ),
                    AspectRatio(aspectRatio: 1, child: _buildAppIcon(context)),
                  ],
                ),
              )
            else ...[
              Expanded(child: _buildAppIcon(context)),
              const TrackInfo(),
            ],
            const SizedBox(height: 16),
            const PlayerProgressBar(),
            _buildBigPlayerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildBigPlayerTopBar() {
    return BlocSelector<PlaylistCubit, PlaylistState, String?>(
      selector:
          (state) => switch (state) {
            final PlaylistStateLoading s => s.selectedPlaylist.name,
            final PlaylistStateSuccess s => s.selectedPlaylist.name,
            _ => null,
          },
      builder: (context, selectedPlaylistName) {
        if (selectedPlaylistName != null) {
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 32,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.l10n.currentPlaylist.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      selectedPlaylistName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildBigPlayerControls() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PlayerShuffleButton(),
        PlayerPreviousButton(),
        PlayerPlayPauseButton(),
        PlayerNextButton(),
        PlayerLoopButton(),
      ],
    );
  }

  Widget _buildAppIcon(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light
          ? appIconPath
          : appIconMonochromePath,
      color:
          Theme.of(context).brightness == Brightness.dark ? Colors.white : null,
    );
  }
}
