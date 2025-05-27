import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/model/track.dart';
import 'package:vidya_music/utils/measurements.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({
    required this.track,
    required this.index,
    this.isCurrent = false,
    super.key,
  });

  final Track track;
  final int index;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        track.toFullTrackName,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isCurrent ? FontWeight.bold : null,
        ),
      ),
      selected: isCurrent,
      onTap: () => context.read<AudioPlayerCubit>().playTrack(track, index),
      minTileHeight: minTrackItemHeight,
    );
  }
}
