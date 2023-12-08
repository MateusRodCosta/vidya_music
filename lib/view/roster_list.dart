import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/view/track_item.dart';

class RosterList extends StatefulWidget {
  const RosterList({super.key});

  @override
  State<RosterList> createState() => _RosterListState();
}

class _RosterListState extends State<RosterList> {
  int? lastScrollPosition;

  Future<void> _scrollToTrack(int? trackIndex) async {
    if (trackIndex == null || trackIndex == lastScrollPosition) return;

    await itemScrollController.scrollTo(
      index: trackIndex,
      duration: const Duration(milliseconds: 300),
    );

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
                Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ).tr(),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text(LocaleKeys.rosterRetry).tr(),
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
              right: !Platform.isIOS,
              top: false,
              bottom: false,
              child: ScrollablePositionedList.separated(
                padding: context.watch<bool>()
                    ? EdgeInsets.only(
                        top: 8,
                        bottom: MediaQuery.of(context).padding.bottom + 8,
                      )
                    : null,
                itemCount: tracks.length,
                itemBuilder: (context, i) {
                  return TrackItem(track: tracks[i], index: i);
                },
                separatorBuilder: (context, i) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                  indent: 16,
                  endIndent: 16,
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
