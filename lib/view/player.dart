import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_scroll/text_scroll.dart';

import '../controller/cubit/audio_player_cubit.dart';
import '../model/track.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      right: !Platform.isIOS,
      top: false,
      bottom: false,
      child: Padding(
        padding: MediaQuery.of(context).size.width >= 600
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
            : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: const Column(
          children: [
            TrackInfo(),
            Controls(),
          ],
        ),
      ),
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioPlayerCubit, AudioPlayerState, Track?>(
      selector: (state) => state.currentTrack,
      builder: (context, currentTrack) {
        if (currentTrack == null) {
          return Text('No track', style: Theme.of(context).textTheme.bodyLarge);
        }

        return Column(
          children: [
            TextScroll(
              '${currentTrack.game} - ${currentTrack.title}',
              style: Theme.of(context).textTheme.bodyLarge,
              delayBefore: const Duration(seconds: 3),
              pauseBetween: const Duration(seconds: 1),
              velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
              intervalSpaces: 10,
            ),
            if (currentTrack.arr != null)
              Text('Arranger: ${currentTrack.arr}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center),
            Text(
                'Composer: ${currentTrack.comp.isEmpty ? '-' : currentTrack.comp}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
          ],
        );
      },
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();
    return Column(
      children: [
        BlocSelector<AudioPlayerCubit, AudioPlayerState,
            (Duration?, Duration?, Duration?)>(
          selector: (state) =>
              (state.trackPosition, state.trackDuration, state.trackBuffered),
          builder: (context, filteredValues) {
            final (trackPosition, trackDuration, trackBuffered) =
                filteredValues;
            return ProgressBar(
              progress: trackPosition ?? Duration.zero,
              total: trackDuration ?? Duration.zero,
              buffered: trackBuffered ?? Duration.zero,
              onSeek: audioPlayerCubit.seek,
              timeLabelLocation: TimeLabelLocation.sides,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
              selector: (state) => state.isShuffle,
              builder: (context, isShuffle) => IconButton(
                onPressed: () async =>
                    audioPlayerCubit.setShuffle(!(isShuffle ?? true)),
                icon: Icon(
                  Icons.shuffle,
                  color: (isShuffle ?? true)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
            IconButton(
                onPressed: () async => audioPlayerCubit.playPrevious(),
                icon: const Icon(Icons.skip_previous)),
            BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
              selector: (state) => state.isPlaying,
              builder: (context, isPlaying) => IconButton(
                onPressed: () async => (isPlaying ?? false)
                    ? audioPlayerCubit.pause()
                    : audioPlayerCubit.play(),
                icon: (isPlaying ?? false)
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
            ),
            IconButton(
              onPressed: () async => audioPlayerCubit.playNext(),
              icon: const Icon(Icons.skip_next),
            ),
            BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
              selector: (state) => state.isLoopTrack,
              builder: (context, isLoopTrack) => IconButton(
                onPressed: () async =>
                    audioPlayerCubit.setLoopTrack(!(isLoopTrack ?? false)),
                icon: (isLoopTrack ?? false)
                    ? Icon(Icons.repeat_one,
                        color: Theme.of(context).colorScheme.primary)
                    : const Icon(Icons.repeat),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
