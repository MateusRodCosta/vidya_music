import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int? lastScrollPosition;

  void _scrollToTrack(int? trackIndex) {
    if (trackIndex == null || trackIndex == lastScrollPosition) return;
    //final previousScrollPosition = currentScrollPosition ?? 0;
    //final newScrollPosition = trackIndex;

    itemScrollController
        .scrollTo(
            index: trackIndex, duration: const Duration(milliseconds: 300))
        .then((_) => lastScrollPosition = trackIndex);
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
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
            listenWhen: (previous, current) =>
                lastScrollPosition == null ||
                lastScrollPosition != current.currentTrackIndex,
            listener: (context, state) {
              _scrollToTrack(state.currentTrackIndex);
            },
            child: SafeArea(
              left: true,
              right: !Platform.isIOS,
              top: false,
              bottom: false,
              child: ScrollablePositionedList.separated(
                padding: context.watch<bool>()
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
                    await context.read<PlaylistCubit>().fetchRoster();
                  }),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is PlaylistStateSuccess) {
          context
              .read<AudioPlayerCubit>()
              .setPlaylist((state.selectedPlaylist, state.roster));
        }
      },
    );
  }
}
