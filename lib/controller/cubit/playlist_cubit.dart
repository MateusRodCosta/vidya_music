import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  late List<Playlist> _availablePlaylists;
  late Playlist _selectedRoster;

  PlaylistCubit() : super(PlaylistStateInitial()) {
    _decodePlaylists();
  }

  void _decodePlaylists() async {
    final js = await rootBundle.loadString('assets/playlists.json');
    final decoded = json.decode(js) as List<dynamic>;
    final lists = decoded.map((d) => Playlist.fromJson(d)).toList();

    _availablePlaylists = List.from(lists)
      ..sort(
        (a, b) => a.order.compareTo(b.order),
      );

    emit(PlaylistStateDecoded(_availablePlaylists));

    final defaultPlaylist = _availablePlaylists.singleWhere(
      (p) => p.isDefault,
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
      final roster = Roster.fromJson(js, isSrc: _selectedRoster.isSource);
      emit(PlaylistStateSuccess(_availablePlaylists, _selectedRoster, roster));
    } catch (e) {
      emit(PlaylistStateError(_availablePlaylists));
    }
  }
}
