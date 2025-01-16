import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/model/track.dart';

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
