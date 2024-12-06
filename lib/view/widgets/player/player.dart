import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/model/track.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/view/widgets/player/player_controls.dart';
import 'package:vidya_music/view/widgets/player/player_progress_bar.dart';

class AppMiniPlayer extends StatelessWidget {
  const AppMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseHeight = playerMinHeight + MediaQuery.of(context).padding.bottom;
    final controller = context.watch<SettingsProvider>().miniplayerController;

    return Miniplayer(
      controller: controller,
      minHeight: baseHeight,
      maxHeight: MediaQuery.of(context).size.height,
      builder: (height, percentage) {
        if (height < baseHeight + 48) {
          return SizedBox(
            width: double.infinity,
            child: Card.filled(
              color: Theme.of(context).colorScheme.secondaryContainer,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: MiniPlayerProgressBar(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'hero-trackinfo',
                              child: TrackInfo(isMiniPlayer: true),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'hero-playpause',
                                child:
                                    PlayerPlayPauseButton(isMiniPlayer: true),
                              ),
                              Hero(
                                tag: 'hero-next',
                                child: PlayerNextButton(isMiniPlayer: true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Card.filled(
          color: Theme.of(context).colorScheme.secondaryContainer,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisAlignment: percentage > 0.7
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (percentage > 0.7)
                  BlocBuilder<PlaylistCubit, PlaylistState>(
                    builder: (context, state) {
                      if (state is PlaylistStateSuccess) {
                        return Row(
                          children: [
                            const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 32,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    LocaleKeys.currentPlaylist
                                        .tr()
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                  ),
                if (percentage > 0.3)
                  Expanded(
                    child: Expanded(
                      child: Image.asset(appIconPath),
                    ),
                  ),
                const Hero(
                  tag: 'hero-trackinfo',
                  child: TrackInfo(),
                ),
                if (height > baseHeight + 192) ...[
                  const SizedBox(height: 16),
                  const PlayerProgressBar(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PlayerShuffleButton(),
                      PlayerPreviousButton(),
                      Hero(
                        tag: 'hero-playpause',
                        child: PlayerPlayPauseButton(),
                      ),
                      Hero(
                        tag: 'hero-next',
                        child: PlayerNextButton(),
                      ),
                      PlayerLoopButton(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key, this.isMiniPlayer = false});

  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioPlayerCubit, AudioPlayerState, Track?>(
      selector: (state) => state.currentTrack,
      builder: (context, currentTrack) {
        final textStyle = Theme.of(context).textTheme.bodyLarge;
        if (currentTrack == null) {
          return Text(LocaleKeys.playerNoTrack, style: textStyle).tr();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextScroll(
              currentTrack.title,
              delayBefore: const Duration(seconds: 3),
              pauseBetween: const Duration(seconds: 1),
              velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
              intervalSpaces: 10,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextScroll(
              currentTrack.game,
              delayBefore: const Duration(seconds: 3),
              pauseBetween: const Duration(seconds: 1),
              velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
              intervalSpaces: 10,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (!isMiniPlayer) ...[
              if (currentTrack.arr != null)
                Text(
                  LocaleKeys.playerArranger,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ).tr(args: [currentTrack.arr!]),
              if (currentTrack.comp.isNotEmpty)
                Text(
                  LocaleKeys.playerComposer,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ).tr(
                  args: [currentTrack.comp],
                ),
            ],
          ],
        );
      },
    );
  }
}
