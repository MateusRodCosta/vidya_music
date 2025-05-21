import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/model/track.dart';
import 'package:vidya_music/utils/l10n_ext.dart';

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
          return Text(context.l10n.playerNoTrack, style: textStyle);
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
                  context.l10n.playerArranger(currentTrack.arr!),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              if (currentTrack.comp.isNotEmpty)
                Text(
                  context.l10n.playerComposer(currentTrack.comp),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
            ],
          ],
        );
      },
    );
  }
}
