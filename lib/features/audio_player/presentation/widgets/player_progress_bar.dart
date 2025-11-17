import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/features/audio_player/presentation/bloc/audio_player_cubit.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({super.key, this.isMiniPlayer = false});

  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();
    final baseColor = Theme.of(context).colorScheme.tertiary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return BlocSelector<
      AudioPlayerCubit,
      AudioPlayerState,
      (Duration, Duration, Duration)
    >(
      selector: (state) => (
        state.position,
        state.duration,
        state.buffered,
      ),
      builder: (context, filteredValues) {
        final (position, duration, buffered) = filteredValues;
        return AbsorbPointer(
          absorbing: isMiniPlayer,
          child: ProgressBar(
            progress: position,
            total: duration,
            buffered: buffered,
            onSeek: audioPlayerCubit.seek,
            baseBarColor: secondaryColor.withValues(alpha: 0.1),
            progressBarColor: baseColor,
            bufferedBarColor: baseColor.withValues(alpha: 0.24),
            thumbColor: baseColor,
            timeLabelLocation: isMiniPlayer ? TimeLabelLocation.none : null,
            thumbRadius: isMiniPlayer ? 2.0 : 10.0,
          ),
        );
      },
    );
  }
}
