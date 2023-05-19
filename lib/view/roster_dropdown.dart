import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/playlist_cubit.dart';

import '../model/playlist.dart';

class RosterDropdown extends StatefulWidget {
  const RosterDropdown({super.key});

  @override
  State<RosterDropdown> createState() => _RosterDropdownState();
}

class _RosterDropdownState extends State<RosterDropdown> {
  Playlist? currentRoster;
  List<Playlist>? availablePlaylists;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(builder: (context, rs) {
      if (rs is PlaylistStateLoading) {
        currentRoster = rs.selectedRoster;
        availablePlaylists = rs.availablePlaylists;
      }
      if (rs is PlaylistStateSuccess) {
        currentRoster = rs.selectedRoster;
        availablePlaylists = rs.availablePlaylists;
      }
      if (rs is PlaylistStateError) {
        availablePlaylists = rs.availablePlaylists;
      }
      return DropdownButtonHideUnderline(
        child: DropdownButton<Playlist>(
          value: currentRoster,
          items: availablePlaylists
              ?.map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.name),
                ),
              )
              .toList(),
          onChanged: (playlist) async {
            await BlocProvider.of<PlaylistCubit>(context).setPlaylist(playlist);
          },
        ),
      );
    });
  }
}
