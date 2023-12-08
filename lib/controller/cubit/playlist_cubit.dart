import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/model/config.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:vidya_music/utils/branding.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistStateInitial()) {
    _decodeConfig();
  }

  late List<Playlist> _availablePlaylists;
  late Playlist _selectedRoster;

  Future<void> _decodeConfig() async {
    final js = await rootBundle.loadString(playlistConfigPath);
    final decoded = json.decode(js) as Map<String, dynamic>;
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
      final js = jsonDecode(r) as Map<String, dynamic>;
      final roster = Roster.fromJson(js, getSource: _selectedRoster.isSource);
      emit(PlaylistStateSuccess(_availablePlaylists, _selectedRoster, roster));
    } on SocketException catch (e) {
      emit(
        PlaylistStateError(
          errorMessage: LocaleKeys.rosterErrorCouldntFetch,
          availablePlaylists: _availablePlaylists,
        ),
      );
      developer.log(e.toString(), name: 'fetchRoster');
    } catch (e) {
      emit(PlaylistStateError(availablePlaylists: _availablePlaylists));
      developer.log(e.toString(), name: 'fetchRoster');
    }
  }
}
