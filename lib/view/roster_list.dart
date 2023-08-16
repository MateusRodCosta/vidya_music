import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/view/track_item.dart';

class RosterList extends StatefulWidget {
  const RosterList({super.key});

  @override
  State<RosterList> createState() => _RosterListState();
}

class _RosterListState extends State<RosterList> {
  int? scrollPosition;

  void scrollToTrack(int? index) {
    if (index == null || index == scrollPosition) return;
    scrollPosition = index;

    itemScrollController.scrollTo(
        index: index, duration: const Duration(milliseconds: 300));
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();

    return BlocConsumer<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PlaylistStateSuccess) {
          final tracks = state.roster.tracks;

          return BlocListener<AudioPlayerCubit, AudioPlayerState>(
            listener: (context, aps) {
              scrollToTrack(aps.currentTrackIndex);
            },
            child: SafeArea(
              left: true,
              right: !Platform.isIOS,
              top: false,
              bottom: false,
              child: ScrollablePositionedList.separated(
                padding: Provider.of<bool>(context)
                    ? EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom)
                    : null,
                itemCount: tracks.length,
                itemBuilder: (context, i) {
                  return TrackItem(track: tracks[i], index: i);
                },
                separatorBuilder: (context, i) => Divider(
                  height: 1.0,
                  thickness: 0.0,
                  color: Theme.of(context).dividerColor,
                  indent: 8,
                  endIndent: 8,
                ),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              ),
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't fetch tracks"),
              ElevatedButton(
                  child: const Text('Try again'),
                  onPressed: () async {
                    await BlocProvider.of<PlaylistCubit>(context).fetchRoster();
                  }),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is PlaylistStateSuccess) {
          BlocProvider.of<AudioPlayerCubit>(context)
              .setPlaylist((state.selectedPlaylist, state.roster));
        }
      },
    );
  }
}
