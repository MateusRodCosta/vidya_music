import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';

class MiniPlayerProgressBar extends StatelessWidget {
  const MiniPlayerProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.tertiary;

    return BlocSelector<AudioPlayerCubit, AudioPlayerState,
        (Duration?, Duration?, Duration?)>(
      selector: (state) =>
          (state.trackPosition, state.trackDuration, state.trackBuffered),
      builder: (context, filteredValues) {
        final (trackPosition, trackDuration, trackBuffered) = filteredValues;

        final percentagePlayed = trackPosition != null && trackDuration != null
            ? trackPosition.inMilliseconds / trackDuration.inMilliseconds
            : 0.0;
        final percentageBuffered =
            trackBuffered != null && trackDuration != null
                ? trackBuffered.inMilliseconds / trackDuration.inMilliseconds
                : 0.0;

        return SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              LinearProgressIndicator(
                value: percentageBuffered,
                color: baseColor.withOpacity(0.24),
                borderRadius: BorderRadius.circular(10),
              ),
              LinearProgressIndicator(
                value: percentagePlayed,
                color: baseColor,
                backgroundColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();
    final baseColor = Theme.of(context).colorScheme.tertiary;

    return BlocSelector<AudioPlayerCubit, AudioPlayerState,
        (Duration?, Duration?, Duration?)>(
      selector: (state) =>
          (state.trackPosition, state.trackDuration, state.trackBuffered),
      builder: (context, filteredValues) {
        final (trackPosition, trackDuration, trackBuffered) = filteredValues;
        return ProgressBar(
          progress: trackPosition ?? Duration.zero,
          total: trackDuration ?? Duration.zero,
          buffered: trackBuffered,
          onSeek: audioPlayerCubit.seek,
          baseBarColor: baseColor.withOpacity(0.24),
          progressBarColor: baseColor,
          bufferedBarColor: baseColor.withOpacity(0.24),
          thumbColor: baseColor,
        );
      },
    );
  }
}
