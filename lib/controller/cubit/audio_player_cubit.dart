import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/controller/services/audio_player_singleton.dart';
import 'package:vidya_music/model/playlist.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:vidya_music/model/track.dart';
import 'package:vidya_music/utils/utils.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit()
    : _player = AudioPlayerSingleton.instance,
      super(const AudioPlayerState()) {
    _setupArt();
    _setupStreamSubscriptions();
  }

  late final StreamSubscription<Duration?> onDurationSubscription;
  late final StreamSubscription<Duration> onPositionSubscription;
  late final StreamSubscription<Duration> onBufferedPositionSubscription;
  late final StreamSubscription<bool> onPlayingSubscription;
  late final StreamSubscription<int?> onCurrentIndexSubscription;

  final AudioPlayer _player;
  Uri? _playerArtUri;

  late Playlist _currentPlaylist;
  late Roster _roster;

  Future<void> _setupArt() async {
    _playerArtUri = await getPlayerArtFileFromAssets();
  }

  void _setupStreamSubscriptions() {
    onDurationSubscription = _player.durationStream.listen(_onDurationChanged);
    onPositionSubscription = _player.positionStream.listen(_onPositionChanged);
    onBufferedPositionSubscription = _player.bufferedPositionStream.listen(
      _onBufferedPositionChanged,
    );
    onPlayingSubscription = _player.playingStream.listen(_onPlayingChanged);
    onCurrentIndexSubscription = _player.currentIndexStream.listen(
      _onCurrentIndex,
    );
  }

  Future<void> setPlaylist((Playlist, Roster) newPlaylistPair) async {
    _currentPlaylist = newPlaylistPair.$1;
    _roster = newPlaylistPair.$2;

    await _loadTracksAndPlay();
  }

  Future<void> _loadTracksAndPlay() async {
    final tracks = _generateTrackList();

    await _player.setAudioSources(tracks, shuffleOrder: DefaultShuffleOrder());

    final initialShuffle = state.isShuffle ?? true;
    await _player.setShuffleModeEnabled(initialShuffle);
    // Skip first track on playlist load
    // It's usually the "welcome" track ("You're listening to the VIP")
    await _player.seekToNext();
    await _player.play();

    emit(state.copyWith(isShuffle: initialShuffle));
  }

  List<AudioSource> _generateTrackList() {
    return _roster.tracks.map(_generateAudioSource).toList();
  }

  AudioSource _generateAudioSource(Track track) {
    return AudioSource.uri(
      _generateTrackUri(track),
      tag: MediaItem(
        id: '${_currentPlaylist.name}_${track.id}',
        title: track.title,
        artist: track.game,
        artUri: _playerArtUri,
      ),
    );
  }

  Future<void> playTrack(Track track, int trackIndex) async {
    await _player.seek(Duration.zero, index: trackIndex);
  }

  Uri _generateTrackUri(Track track) {
    final filename = '${track.file}.${_roster.ext}';
    final sourcePath =
        track.isSrcTrack ? (_currentPlaylist.extras?.sourcePath ?? '') : '';
    final url = '${_roster.url}$sourcePath$filename';

    final uri = Uri.parse(url);

    return uri;
  }

  Future<void> play() async => _player.play();

  Future<void> pause() async => _player.pause();

  Future<void> seek(Duration? d) async => _player.seek(d);

  Future<void> playPrevious() async => _player.seekToPrevious();

  Future<void> playNext() async => _player.seekToNext();

  Future<void> setShuffle({required bool shuffleMode}) async {
    await _player.setShuffleModeEnabled(shuffleMode);
    emit(state.copyWith(isShuffle: shuffleMode));
  }

  Future<void> setLoopTrack({required bool loopTrack}) async {
    await _player.setLoopMode(loopTrack ? LoopMode.one : LoopMode.off);
    emit(state.copyWith(isLoopTrack: loopTrack));
  }

  void _onDurationChanged(Duration? v) {
    emit(state.copyWith(trackDuration: v));
  }

  void _onPositionChanged(Duration v) {
    emit(state.copyWith(trackPosition: v));
  }

  void _onBufferedPositionChanged(Duration v) {
    emit(state.copyWith(trackBuffered: v));
  }

  void _onPlayingChanged(bool v) {
    emit(state.copyWith(isPlaying: v));
  }

  void _onCurrentIndex(int? index) {
    if (index == null) return;

    emit(
      state.copyWith(
        currentTrackIndex: index,
        currentTrack: _roster.tracks[index],
      ),
    );
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
