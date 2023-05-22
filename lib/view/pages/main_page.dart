import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/cubit/playlist_cubit.dart';
import '../../model/playlist.dart';
import '../app_drawer.dart';
import '../player.dart';
import '../roster_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
      ),
      endDrawer: const AppDrawer(),
      body: const Column(
        children: [
          Player(),
          Expanded(child: RosterList()),
        ],
      ),
    );
  }

  BlocBuilder<PlaylistCubit, PlaylistState> _buildTitle() {
    Playlist? currentPlaylist;

    return BlocBuilder<PlaylistCubit, PlaylistState>(builder: (context, rs) {
      if (rs is PlaylistStateLoading) {
        currentPlaylist = rs.selectedRoster;
      }
      if (rs is PlaylistStateSuccess) {
        currentPlaylist = rs.selectedRoster;
      }
      return InkWell(
        onTap: () {
          Scaffold.of(context).openEndDrawer();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${widget.title}${currentPlaylist != null ? ' - ${currentPlaylist!.name}' : ''}'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      );
    });
  }
}
