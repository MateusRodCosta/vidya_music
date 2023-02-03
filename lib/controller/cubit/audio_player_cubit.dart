import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:vidya_music/model/track.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(const AudioPlayerState()) {
    _playerInstance = AudioPlayer();
  }

  late AudioPlayer _playerInstance;
  late Roster roster;

  AudioPlayer get player => _playerInstance;

  late StreamSubscription<Duration?> onDurationSubscription;
  late StreamSubscription<Duration> onPositionSubscription;
  late StreamSubscription<Duration> onBufferedPositionSubscription;
  late StreamSubscription<bool> onPlayingSubscription;
  late StreamSubscription<ProcessingState> onProcessingStateSubscription;

  void initializePlayer(Roster rost) {
    roster = rost;

    onDurationSubscription = player.durationStream.listen(_onDurationChanged);

    onPositionSubscription = player.positionStream.listen(_onPositionChanged);

    onBufferedPositionSubscription =
        player.bufferedPositionStream.listen(_onBufferedPositionChanged);

    onPlayingSubscription = player.playingStream.listen(_onPlayingChanged);

    onProcessingStateSubscription =
        player.processingStateStream.listen(_onProcessingStateChanged);

    playRandomTrack();
  }

  void playTrack(Track track, [int? trackIndex]) async {
    final uri = _findTrackUri(track);

    emit(state.copyWith(currentTrack: track, currentTrackIndex: trackIndex));

    await player.setAudioSource(
      AudioSource.uri(
        uri,
        tag: MediaItem(
          id: '$trackIndex',
          title: track.title,
          artist: track.game,
        ),
      ),
      preload: true,
    );
    await player.play();
  }

  Uri _findTrackUri(Track track) {
    final url = '${roster.url}${track.file}.${roster.ext}';

    final uri = Uri.parse(url);

    return uri;
  }

  void pause() async {
    await player.pause();
  }

  void play() async {
    if (state.currentTrack == null) {
      playRandomTrack();
    } else {
      await player.play();
    }
  }

  void playRandomTrack() {
    final numTracks = roster.tracks.length;

    final next = Random.secure().nextInt(numTracks);

    playTrack(roster.tracks[next], next);
  }

  void seek(Duration? d) {
    player.seek(d);
  }

  void playPrevious() {
    final numTracks = roster.tracks.length;

    if (state.currentTrackIndex == null) return;
    final prev = (state.currentTrackIndex! - 1).clamp(0, numTracks);

    playTrack(roster.tracks[prev], prev);
  }

  void playNext() {
    final numTracks = roster.tracks.length;

    if (state.currentTrackIndex == null) return;
    final prev = (state.currentTrackIndex! + 1).clamp(0, numTracks);

    playTrack(roster.tracks[prev], prev);
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

  void _onProcessingStateChanged(ProcessingState ps) {
    if (ps == ProcessingState.completed) {
      playRandomTrack();
    }
  }

  @override
  Future<void> close() {
    player.dispose();
    onDurationSubscription.cancel();
    onPositionSubscription.cancel();
    onBufferedPositionSubscription.cancel();
    onPlayingSubscription.cancel();
    onProcessingStateSubscription.cancel();

    return super.close();
  }
}
