import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    final apCubit = BlocProvider.of<AudioPlayerCubit>(context, listen: false);
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        builder: (context, aps) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            aps.currentTrack == null
                ? Text('No track', style: Theme.of(context).textTheme.bodyLarge)
                : Column(
                    children: [
                      Text(
                        '${aps.currentTrack!.game} - ${aps.currentTrack!.title}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      if (aps.currentTrack!.arr != null)
                        Text('Arranger: ${aps.currentTrack!.arr}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      Text(
                          'Composer: ${aps.currentTrack!.comp.isEmpty ? '-' : aps.currentTrack!.comp}',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center),
                    ],
                  ),
            ProgressBar(
              progress: aps.trackPosition ?? const Duration(seconds: 0),
              total: aps.trackDuration ?? const Duration(seconds: 0),
              buffered: aps.trackBuffered ?? const Duration(seconds: 0),
              onSeek: apCubit.seek,
              timeLabelLocation: TimeLabelLocation.sides,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: apCubit.playPrevious,
                    icon: const Icon(Icons.skip_previous)),
                IconButton(
                  onPressed: () {
                    (aps.playing ?? false) ? apCubit.pause() : apCubit.play();
                  },
                  icon: (aps.playing ?? false)
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                ),
                IconButton(
                    onPressed: apCubit.playNext,
                    icon: const Icon(Icons.skip_next)),
              ],
            ),
          ],
        ),
      );
    });
  }
}
