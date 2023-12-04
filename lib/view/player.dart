import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/model/track.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: !Platform.isIOS,
      top: false,
      bottom: false,
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        margin: MediaQuery.of(context).size.width >= 600
            ? const EdgeInsets.only(top: 8, left: 16, right: 16)
            : const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              TrackInfo(),
              Controls(),
            ],
          ),
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
        final defaultColor = Theme.of(context).colorScheme.onSecondaryContainer;
        final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge;
        final textStyle = bodyLargeStyle?.copyWith(color: defaultColor) ??
            TextStyle(color: defaultColor);
        if (currentTrack == null) {
          return Text(LocaleKeys.playerNoTrack, style: textStyle).tr();
        }
        return DefaultTextStyle(
          style: textStyle,
          child: Column(
            children: [
              TextScroll(
                '${currentTrack.game} - ${currentTrack.title}',
                delayBefore: const Duration(seconds: 3),
                pauseBetween: const Duration(seconds: 1),
                velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                intervalSpaces: 10,
              ),
              if (currentTrack.arr != null)
                Text(
                  '${LocaleKeys.playerArranjer.tr()}: ${currentTrack.arr}',
                  textAlign: TextAlign.center,
                ),
              Text(
                '${LocaleKeys.playerComposer.tr()}: '
                '${currentTrack.comp.isEmpty ? '-' : currentTrack.comp}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
    final defaultColor = Theme.of(context).colorScheme.onSecondaryContainer;
    final accentColor = Theme.of(context).colorScheme.tertiary;

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
              buffered: trackBuffered,
              onSeek: audioPlayerCubit.seek,
              baseBarColor: accentColor.withOpacity(0.24),
              progressBarColor: accentColor,
              bufferedBarColor: accentColor.withOpacity(0.24),
              thumbColor: accentColor,
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
                onPressed: () async => audioPlayerCubit.setShuffle(
                  shuffleMode: !(isShuffle ?? true),
                ),
                icon: Icon(
                  Icons.shuffle,
                  color: (isShuffle ?? true) ? accentColor : defaultColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () async => audioPlayerCubit.playPrevious(),
              icon: Icon(Icons.skip_previous, color: defaultColor),
            ),
            BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
              selector: (state) => state.isPlaying,
              builder: (context, isPlaying) => IconButton(
                onPressed: () async => (isPlaying ?? false)
                    ? audioPlayerCubit.pause()
                    : audioPlayerCubit.play(),
                icon: Icon(
                  (isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
                  color: defaultColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () async => audioPlayerCubit.playNext(),
              icon: Icon(Icons.skip_next, color: defaultColor),
            ),
            BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
              selector: (state) => state.isLoopTrack,
              builder: (context, isLoopTrack) => IconButton(
                onPressed: () async => audioPlayerCubit.setLoopTrack(
                  loopTrack: !(isLoopTrack ?? false),
                ),
                icon: (isLoopTrack ?? false)
                    ? Icon(Icons.repeat_one, color: accentColor)
                    : Icon(Icons.repeat, color: defaultColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
