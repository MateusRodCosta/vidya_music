import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/controller/services/audio_player_singleton.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:vidya_music/model/track.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(const AudioPlayerState()) {
    _initializePlayer();
  }

  late StreamSubscription<Duration?> onDurationSubscription;
  late StreamSubscription<Duration> onPositionSubscription;
  late StreamSubscription<Duration> onBufferedPositionSubscription;
  late StreamSubscription<bool> onPlayingSubscription;
  late StreamSubscription<int?> onCurrentIndexSubscription;

  late AudioPlayer _player;
  late Playlist _selectedPlaylist;
  late Roster _roster;

  void _initializePlayer() {
    _player = AudioPlayerSingleton.instance;

    onDurationSubscription = _player.durationStream.listen(_onDurationChanged);

    onPositionSubscription = _player.positionStream.listen(_onPositionChanged);

    onBufferedPositionSubscription =
        _player.bufferedPositionStream.listen(_onBufferedPositionChanged);

    onPlayingSubscription = _player.playingStream.listen(_onPlayingChanged);

    onCurrentIndexSubscription =
        _player.currentIndexStream.listen(_onCurrentIndex);
  }

  Future<void> setPlaylist(Playlist selectedPlaylist, Roster roster) async {
    _selectedPlaylist = selectedPlaylist;
    _roster = roster;

    await _initializePlaylist();
  }

  Future<void> _initializePlaylist() async {
    final tracks = _roster.tracks.map((t) => _trackToAudioSource(t)).toList();

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: tracks,
    );

    final initialIndex = _selectRandomTrack();
    await _player.setAudioSource(playlist,
        initialIndex: initialIndex, initialPosition: Duration.zero);

    final initialShuffle = state.isShuffle ?? true;
    await _player.setShuffleModeEnabled(initialShuffle);
    await _player.play();

    emit(state.copyWith(isShuffle: initialShuffle));
  }

  AudioSource _trackToAudioSource(Track track) {
    return AudioSource.uri(_findTrackUri(track),
        tag: MediaItem(
          id: '${_selectedPlaylist.name}_${track.id}',
          title: track.title,
          artist: track.game,
        ));
  }

  Future<void> playTrack(Track track, int trackIndex) async {
    await _player.seek(Duration.zero, index: trackIndex);
  }

  Uri _findTrackUri(Track track) {
    final url =
        '${_roster.url}${_selectedPlaylist.isSource ? _selectedPlaylist.additionalPath : ''}${track.file}.${_roster.ext}';

    final uri = Uri.parse(url);

    return uri;
  }

  int _selectRandomTrack() {
    final numTracks = _roster.tracks.length;

    final r = Random.secure().nextInt(numTracks);

    return r;
  }

  Future<void> play() async => await _player.play();

  Future<void> pause() async => await _player.pause();

  Future<void> seek(Duration? d) async => await _player.seek(d);

  Future<void> playPrevious() async => await _player.seekToPrevious();

  Future<void> playNext() async => await _player.seekToNext();

  Future<void> setShuffle(bool shuffleMode) async {
    await _player.setShuffleModeEnabled(shuffleMode);
    emit(state.copyWith(isShuffle: shuffleMode));
  }

  Future<void> setLoopTrack(bool loopTrack) async {
    await _player.setLoopMode(loopTrack ? LoopMode.one : LoopMode.off);
    emit(state.copyWith(isLoopTrack: loopTrack));
  }

  void _onDurationChanged(Duration? d) {
    emit(state.copyWith(trackDuration: d));
  }

  void _onPositionChanged(Duration d) {
    emit(state.copyWith(trackPosition: d));
  }

  void _onBufferedPositionChanged(Duration d) {
    emit(state.copyWith(trackBuffered: d));
  }

  void _onPlayingChanged(bool p) {
    emit(state.copyWith(playing: p));
  }

  void _onCurrentIndex(int? index) {
    if (index == null) return;

    emit(state.copyWith(
        currentTrackIndex: index, currentTrack: _roster.tracks[index]));
  }

  @override
  Future<void> close() async {
    await _player.stop();
    await _player.dispose();

    await onDurationSubscription.cancel();
    await onPositionSubscription.cancel();
    await onBufferedPositionSubscription.cancel();
    await onPlayingSubscription.cancel();
    await onCurrentIndexSubscription.cancel();

    return super.close();
  }
}
