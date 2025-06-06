import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';
import 'package:vidya_music/utils/build_context_l10n_ext.dart';
import 'package:vidya_music/utils/measurements.dart';
import 'package:vidya_music/view/widgets/track_item.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

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
                  state.errorMessage.l10n(context),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: Text(context.l10n.rosterRetry),
                  onPressed:
                      () async => context.read<PlaylistCubit>().loadRoster(),
                ),
              ],
            ),
          );
        }
        if (state is PlaylistStateSuccess) {
          final tracks = state.roster.tracks;

          return BlocListener<AudioPlayerCubit, AudioPlayerState>(
            listenWhen:
                (previous, current) =>
                    previous.currentTrackIndex != current.currentTrackIndex,
            listener:
                (context, state) async =>
                    _scrollToTrack(state.currentTrackIndex),
            child: BlocSelector<AudioPlayerCubit, AudioPlayerState, int?>(
              selector: (state) => state.currentTrackIndex,
              builder: (context, currentTrackIndex) {
                return ScrollConfiguration(
                  behavior: _ScrollbarBehavior(),
                  child: ScrollablePositionedList.separated(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom:
                          MediaQuery.of(context).padding.bottom + playerHeight,
                    ),
                    itemCount: tracks.length,
                    itemBuilder: (context, i) {
                      return TrackItem(
                        track: tracks[i],
                        index: i,
                        isCurrent: currentTrackIndex == i,
                      );
                    },
                    separatorBuilder:
                        (context, i) => SafeArea(
                          top: false,
                          bottom: false,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outlineVariant,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ),
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                  ),
                );
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
      listener: (context, state) async {
        if (state is PlaylistStateSuccess) {
          await context.read<AudioPlayerCubit>().setPlaylist((
            state.selectedPlaylist,
            state.roster,
          ));
        }
      },
    );
  }
}

class _ScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return VsScrollbar(
      controller: details.controller,
      isAlwaysShown: true,
      style: VsScrollbarStyle(color: Theme.of(context).colorScheme.primary),
      child: child,
    );
  }
}
