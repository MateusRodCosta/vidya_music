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
  late AudioPlayer _player;

  late Roster _roster;

  AudioPlayerCubit() : super(const AudioPlayerState()) {
    _initializePlayer();
  }

  late StreamSubscription<Duration?> onDurationSubscription;
  late StreamSubscription<Duration> onPositionSubscription;
  late StreamSubscription<Duration> onBufferedPositionSubscription;
  late StreamSubscription<bool> onPlayingSubscription;
  late StreamSubscription<int?> onCurrentIndexSubscription;

  late Playlist _selectedPlaylist;

  late ConcatenatingAudioSource _playlist;

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

    _playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: tracks,
    );

    final initialIndex = _selectRandomTrack();
    await _player.setAudioSource(_playlist,
        initialIndex: initialIndex, initialPosition: Duration.zero);

    await _player.setShuffleModeEnabled(true);
    await _player.play();
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
