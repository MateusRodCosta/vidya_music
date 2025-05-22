import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:vidya_music/model/config.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:vidya_music/utils/branding.dart';
import 'package:vidya_music/utils/cubit_l10n_keys.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistStateInitial()) {
    _decodeConfig();
  }

  late final List<Playlist> _availablePlaylists;
  Playlist? _selectedPlaylist;

  Future<void> _decodeConfig() async {
    try {
      final js = await rootBundle.loadString(playlistConfigPath);
      final decoded = json.decode(js) as Map<String, dynamic>;
      final config = Config.fromJson(decoded);

      _availablePlaylists =
          config.playlists..sort((a, b) => a.order.compareTo(b.order));
      emit(PlaylistStateDecoded(_availablePlaylists));

      final defaultPlaylist = _availablePlaylists.singleWhere(
        (p) => p.id == config.defaultPlaylist,
        orElse: () => _availablePlaylists.first,
      );

      _selectedPlaylist = defaultPlaylist;
      await loadRoster();
    } on Exception catch (e) {
      _availablePlaylists = [];
      _emitErrorState(
        CubitL10nKeys.playlistConfigDecodingError,
        e,
        '_decodeConfig',
      );
    }
  }

  Future<void> setPlaylist(Playlist? playlist) async {
    if (playlist == null || playlist == _selectedPlaylist) return;
    _selectedPlaylist = playlist;
    await loadRoster();
  }

  Future<void> loadRoster() async {
    if (_selectedPlaylist == null) return;

    try {
      final selectedPlaylist = _selectedPlaylist!;
      final (url, isSource) = (selectedPlaylist.url, selectedPlaylist.isSource);
      emit(PlaylistStateLoading(_availablePlaylists, selectedPlaylist));
      final roster = await _fetchAndParseRoster(
        Uri.parse(url),
        isSource: isSource,
      );
      emit(PlaylistStateSuccess(_availablePlaylists, selectedPlaylist, roster));
    } on SocketException catch (e) {
      _emitErrorState(CubitL10nKeys.rosterErrorCouldntFetch, e, 'loadRoster');
    } on Exception catch (e) {
      _emitErrorState(CubitL10nKeys.genericError, e, 'loadRoster');
    }
  }

  Future<Roster> _fetchAndParseRoster(Uri url, {bool isSource = false}) async {
    final r = await http.read(url);
    final js = jsonDecode(r) as Map<String, dynamic>;
    final roster = Roster.fromJson(js, getSource: isSource);
    return roster;
  }

  void _emitErrorState(
    CubitL10nKeys errorMessage,
    Object error,
    String method,
  ) {
    emit(
      PlaylistStateError(
        errorMessage: errorMessage,
        availablePlaylists: _availablePlaylists,
      ),
    );
    developer.log(error.toString(), name: method);
  }
}
