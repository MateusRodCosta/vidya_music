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

  late List<(int, Track)> _playlistTracks;
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

    await _generatePlayerPlaylist();
  }

  Future<void> _generatePlayerPlaylist() async {
    final l = <(int, Track)>[];
    for (int i = 0; i < 3; i++) {
      final t = selectRandomTrack();
      l.add(t);
    }

    final pl = l.map((t) => _trackToAudioSource(t.$1, t.$2)).toList();

    _playlistTracks = l;

    final playli = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: pl,
    );

    _playlist = playli;

    await _player.setAudioSource(_playlist,
        initialIndex: 0, initialPosition: Duration.zero);

    await _player.play();
  }

  AudioSource _trackToAudioSource(int id, Track track) {
    return AudioSource.uri(_findTrackUri(track),
        tag: MediaItem(
          id: '${_selectedPlaylist.name}_$id',
          title: track.title,
          artist: track.game,
        ));
  }

  Future<void> playTrack(Track track, int trackIndex) async {
    final current = _player.currentIndex!;

    final playlistTracks = List<(int, Track)>.from(_playlistTracks);
    playlistTracks.removeRange(current + 1, playlistTracks.length);
    final t = (trackIndex, track);
    final tExtra = selectRandomTrack();

    playlistTracks.add(t);
    playlistTracks.add(tExtra);

    final tracks =
        playlistTracks.map((t) => _trackToAudioSource(t.$1, t.$2)).toList();

    final playli = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: tracks,
    );

    _playlistTracks = playlistTracks;
    _playlist = playli;

    await _player.setAudioSource(_playlist,
        initialIndex: current + 1, initialPosition: Duration.zero);
  }

  Uri _findTrackUri(Track track) {
    final url =
        '${_roster.url}${_selectedPlaylist.isSource ? _selectedPlaylist.additionalPath : ''}${track.file}.${_roster.ext}';

    final uri = Uri.parse(url);

    return uri;
  }

  (int, Track) selectRandomTrack() {
    final numTracks = _roster.tracks.length;

    final r = Random.secure().nextInt(numTracks);

    return (r, _roster.tracks[r]);
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
    final currentTrack = _playlistTracks[index];
    emit(state.copyWith(
        currentTrackIndex: currentTrack.$1, currentTrack: currentTrack.$2));

    if (!_player.hasNext) {
      final t = selectRandomTrack();

      _playlistTracks.add(t);
      _playlist.add(_trackToAudioSource(t.$1, t.$2));
    }
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
