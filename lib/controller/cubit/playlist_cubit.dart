import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import '../../model/config.dart';
import '../../model/playlist.dart';
import '../../model/roster.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistStateInitial()) {
    _decodeConfig();
  }

  late List<Playlist> _availablePlaylists;
  late Playlist _selectedRoster;

  void _decodeConfig() async {
    final js = await rootBundle.loadString('assets/config.json');
    final decoded = json.decode(js);
    final config = Config.fromJson(decoded);

    _availablePlaylists = List.from(config.playlists)
      ..sort(
        (a, b) => a.order.compareTo(b.order),
      );

    emit(PlaylistStateDecoded(_availablePlaylists));

    final defaultPlaylist = _availablePlaylists.singleWhere(
      (p) => p.id == config.defaultPlaylist,
      orElse: () => _availablePlaylists.first,
    );

    _selectedRoster = defaultPlaylist;

    await fetchRoster();
  }

  Future<void> setPlaylist(Playlist? playlist) async {
    if (playlist == null || playlist == _selectedRoster) return;
    _selectedRoster = playlist;
    await fetchRoster();
  }

  Future<void> fetchRoster() async {
    final url = _selectedRoster.url;
    try {
      emit(PlaylistStateLoading(_availablePlaylists, _selectedRoster));
      final r = await http.read(Uri.parse(url));
      final js = jsonDecode(r);
      final roster = Roster.fromJson(js, getSource: _selectedRoster.isSource);
      emit(PlaylistStateSuccess(_availablePlaylists, _selectedRoster, roster));
    } catch (e) {
      emit(PlaylistStateError(_availablePlaylists));
    }
  }
}
