import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/view/widgets/player/player.dart';
import 'package:vidya_music/view/widgets/player/player_controls.dart';
import 'package:vidya_music/view/widgets/player/player_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) => const BigPlayer(),
          constraints: const BoxConstraints.expand(),
        );
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Card.filled(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: MiniPlayerProgressBar(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    const Expanded(child: TrackInfo(isMiniPlayer: true)),
                    _buildSimpleControls(),
                  ],
                ),
              ),
            ],
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
            Expanded(
              child: Expanded(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? appIconPath
                      : appIconMonochromePath,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : null,
                ),
              ),
            ),
            const TrackInfo(),
            const SizedBox(height: 16),
            const PlayerProgressBar(),
            _buildBigPlayerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildBigPlayerTopBar() {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistStateSuccess) {
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
                      LocaleKeys.currentPlaylist.tr().toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      state.selectedPlaylist.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
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
}
