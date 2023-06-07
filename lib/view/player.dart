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
    final apCubit = BlocProvider.of<AudioPlayerCubit>(context, listen: false);
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        builder: (context, apState) {
      return SafeArea(
        left: true,
        right: false,
        top: false,
        bottom: false,
        child: Padding(
          padding: MediaQuery.of(context).size.width >= 600
              ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
              : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              apState.currentTrack == null
                  ? Text('No track',
                      style: Theme.of(context).textTheme.bodyLarge)
                  : _buildTrackInfo(context, apState.currentTrack!),
              ProgressBar(
                progress: apState.trackPosition ?? const Duration(seconds: 0),
                total: apState.trackDuration ?? const Duration(seconds: 0),
                buffered: apState.trackBuffered ?? const Duration(seconds: 0),
                onSeek: apCubit.seek,
                timeLabelLocation: TimeLabelLocation.sides,
              ),
              _buildControls(context, apCubit, apState),
            ],
          ),
        ),
      );
    });
  }

  Column _buildTrackInfo(BuildContext context, Track currentTrack) {
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
        Text('Composer: ${currentTrack.comp.isEmpty ? '-' : currentTrack.comp}',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
      ],
    );
  }

  Row _buildControls(BuildContext context, AudioPlayerCubit apCubit,
      AudioPlayerState apState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => apCubit.setShuffle(!(apState.isShuffle ?? true)),
            icon: Icon(
              Icons.shuffle,
              color: (apState.isShuffle ?? true)
                  ? Theme.of(context).colorScheme.primary
                  : null,
            )),
        IconButton(
            onPressed: () => apCubit.playPrevious(),
            icon: const Icon(Icons.skip_previous)),
        IconButton(
          onPressed: () =>
              (apState.playing ?? false) ? apCubit.pause() : apCubit.play(),
          icon: (apState.playing ?? false)
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        ),
        IconButton(
          onPressed: () => apCubit.playNext(),
          icon: const Icon(Icons.skip_next),
        ),
        IconButton(
            onPressed: () =>
                apCubit.setLoopTrack(!(apState.isLoopTrack ?? false)),
            icon: (apState.isLoopTrack ?? false)
                ? Icon(Icons.repeat_one,
                    color: Theme.of(context).colorScheme.primary)
                : const Icon(Icons.repeat)),
      ],
    );
  }
}
