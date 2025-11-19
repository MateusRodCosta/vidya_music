import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:vidya_music/core/utils/cubit_l10n_keys.dart';
import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/domain/entities/roster.dart';
import 'package:vidya_music/features/playlist/domain/usecases/get_config_and_load_roster_usecase.dart';
import 'package:vidya_music/features/playlist/domain/usecases/load_roster_usecase.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit(this._getConfigAndLoadRosterUseCase, this._loadRosterUseCase)
    : super(PlaylistStateInitial()) {
    // ignore: discarded_futures
    _decodeConfig();
  }

  final GetConfigAndLoadRosterUseCase _getConfigAndLoadRosterUseCase;
  final LoadRosterUseCase _loadRosterUseCase;

  List<Playlist>? _availablePlaylists;
  Playlist? _selectedPlaylist;

  Future<void> _decodeConfig() async {
    emit(PlaylistStateInitial());
    try {
      final (config, defaultPlaylist, roster) =
          await _getConfigAndLoadRosterUseCase();
      _availablePlaylists = config.playlists;
      if (_availablePlaylists != null) {
        emit(
          PlaylistStateSuccess(_availablePlaylists!, defaultPlaylist, roster),
        );
      } else {
        throw Exception();
      }
    } on Exception catch (e, s) {
      _emitErrorState(
        errorMessage: CubitL10nKeys.playlistConfigDecodingError,
        method: '_decodeConfig',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> setPlaylist(Playlist? playlist) async {
    if (playlist == null || playlist == _selectedPlaylist) return;
    _selectedPlaylist = playlist;
    await loadRoster();
  }

  Future<void> loadRoster() async {
    if (_availablePlaylists == null) return;
    if (_selectedPlaylist == null) return;

    try {
      final selectedPlaylist = _selectedPlaylist!;
      emit(PlaylistStateLoading(_availablePlaylists!, selectedPlaylist));
      final roster = await _loadRosterUseCase(selectedPlaylist);
      if (roster == null) {
        _emitErrorState(
          errorMessage: CubitL10nKeys.rosterErrorCouldntFetch,
          method: 'loadRoster',
        );
      } else {
        emit(
          PlaylistStateSuccess(_availablePlaylists!, selectedPlaylist, roster),
        );
      }
    } on SocketException catch (e, s) {
      _emitErrorState(
        errorMessage: CubitL10nKeys.rosterErrorCouldntFetch,
        method: 'loadRoster',
        error: e,
        stackTrace: s,
      );
    } on Exception catch (e, s) {
      _emitErrorState(
        errorMessage: CubitL10nKeys.genericError,
        method: 'loadRoster',
        error: e,
        stackTrace: s,
      );
    }
  }

  void _emitErrorState({
    required CubitL10nKeys errorMessage,
    required String method,
    Object? error,
    StackTrace? stackTrace,
  }) {
    emit(
      PlaylistStateError(
        errorMessage: errorMessage,
        availablePlaylists: _availablePlaylists,
      ),
    );
    developer.log(
      error.toString(),
      name: method,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
