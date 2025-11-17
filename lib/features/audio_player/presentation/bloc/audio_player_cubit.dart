import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vidya_music/features/audio_player/data/datasources/audio_player_service.dart';
import 'package:vidya_music/features/playlist/domain/entities/track.dart';
import 'package:vidya_music/features/playlist/presentation/bloc/playlist_cubit.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit({
    required AudioPlayerService audioPlayerService,
    required PlaylistCubit playlistCubit,
  }) : _audioPlayerService = audioPlayerService,
       _playlistCubit = playlistCubit,
       super(const AudioPlayerState()) {
    _playlistSubscription = _playlistCubit.stream.listen((playlistState) {
      if (playlistState is PlaylistStateSuccess) {
        _audioPlayerService.setPlaylist(playlistState.roster.tracks);
        play();
      }
    });

    _setupStreamSubscriptions();
  }

  final AudioPlayerService _audioPlayerService;
  final PlaylistCubit _playlistCubit;

  late final StreamSubscription<PlaylistState> _playlistSubscription;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<Duration> _bufferedSubscription;
  late final StreamSubscription<int?> _currentIndexSubscription;

  void _setupStreamSubscriptions() {
    _playerStateSubscription = _audioPlayerService.playerStateStream.listen((
      playerState,
    ) {
      emit(state.copyWith(isPlaying: playerState.playing));
    });

    _positionSubscription = _audioPlayerService.positionStream.listen((
      position,
    ) {
      emit(state.copyWith(position: position));
    });

    _durationSubscription = _audioPlayerService.durationStream.listen((
      duration,
    ) {
      emit(state.copyWith(duration: duration));
    });

    _bufferedSubscription = _audioPlayerService.bufferedStream.listen((
      buffered,
    ) {
      emit(state.copyWith(buffered: buffered));
    });

    _currentIndexSubscription = _audioPlayerService.currentIndexStream.listen((
      index,
    ) {
      if (index != null) {
        final currentState = _playlistCubit.state;
        if (currentState is PlaylistStateSuccess) {
          if (index < currentState.roster.tracks.length) {
            final currentTrack = currentState.roster.tracks[index];
            emit(
              state.copyWith(
                currentTrack: currentTrack,
                currentTrackIndex: index,
              ),
            );
          }
        }
      }
    });
  }

  Future<void> playTrack(Track track, int trackIndex) async {
    await _audioPlayerService.seek(Duration.zero, index: trackIndex);
  }

  Future<void> play() async => _audioPlayerService.play();
  Future<void> pause() async => _audioPlayerService.pause();

  Future<void> seek(Duration? d) async => _audioPlayerService.seek(d);
  Future<void> seekToNext() async => _audioPlayerService.seekToNext();
  Future<void> seekToPrevious() async => _audioPlayerService.seekToPrevious();

  Future<void> setShuffle({required bool shuffleMode}) async {
    await _audioPlayerService.setShuffle(shuffleMode: shuffleMode);
    emit(state.copyWith(isShuffle: shuffleMode));
  }

  Future<void> setLoopTrack({required bool loopTrack}) async {
    await _audioPlayerService.setLoopTrack(loopTrack: loopTrack);
    emit(state.copyWith(isLoopTrack: loopTrack));
  }

  @override
  Future<void> close() async {
    await _playlistSubscription.cancel();
    await _playerStateSubscription.cancel();
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _bufferedSubscription.cancel();
    await _currentIndexSubscription.cancel();

    _audioPlayerService.dispose();

    return super.close();
  }
}
