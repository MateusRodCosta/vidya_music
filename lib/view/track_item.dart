import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/model/track.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({super.key, required this.track, required this.index});

  final Track track;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          final apcubit =
              BlocProvider.of<AudioPlayerCubit>(context, listen: false);
          apcubit.playTrack(track, index);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
