import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/model/track.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({required this.track, required this.index, super.key});

  final Track track;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const Border(),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async =>
            context.read<AudioPlayerCubit>().playTrack(track, index),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: MediaQuery.of(context).size.width >= 600
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${track.game} - ${track.title}'),
            ),
          ),
        ),
      ),
    );
  }
}
