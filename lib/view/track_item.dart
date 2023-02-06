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
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () async {
          final apcubit =
              BlocProvider.of<AudioPlayerCubit>(context, listen: false);
          await apcubit.playTrack(track, index);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: Padding(
            padding: MediaQuery.of(context).size.width >= 600
                ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
                : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
