import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controller/cubit/audio_player_cubit.dart';
import '../controller/cubit/playlist_cubit.dart';
import 'track_item.dart';

class RosterList extends StatefulWidget {
  const RosterList({super.key});

  @override
  State<RosterList> createState() => _RosterListState();
}

class _RosterListState extends State<RosterList> {
  int? lastScrollPosition;

  Future<void> _scrollToTrack(int? trackIndex) async {
    if (trackIndex == null || trackIndex == lastScrollPosition) return;
    //final previousScrollPosition = currentScrollPosition ?? 0;
    //final newScrollPosition = trackIndex;

    await itemScrollController.scrollTo(
        index: trackIndex, duration: const Duration(milliseconds: 300));

    lastScrollPosition = trackIndex;
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistStateError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Couldn't fetch tracks"),
                ElevatedButton(
                  child: const Text('Try again'),
                  onPressed: () async =>
                      context.read<PlaylistCubit>().fetchRoster(),
                ),
              ],
            ),
          );
        }
        if (state is PlaylistStateSuccess) {
          final tracks = state.roster.tracks;

          return BlocListener<AudioPlayerCubit, AudioPlayerState>(
            listenWhen: (previous, current) =>
                lastScrollPosition == null ||
                lastScrollPosition != current.currentTrackIndex,
            listener: (context, state) async =>
                _scrollToTrack(state.currentTrackIndex),
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

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      listener: (context, state) async {
        if (state is PlaylistStateSuccess) {
          await context
              .read<AudioPlayerCubit>()
              .setPlaylist((state.selectedPlaylist, state.roster));
        }
      },
    );
  }
}
