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
  AudioPlayerCubit() : super(const AudioPlayerState());

  StreamSubscription<Duration?>? onDurationSubscription;
  StreamSubscription<Duration>? onPositionSubscription;
  StreamSubscription<Duration>? onBufferedPositionSubscription;
  StreamSubscription<bool>? onPlayingSubscription;
  StreamSubscription<ProcessingState>? onProcessingStateSubscription;

  void initializePlayer(Roster roster) {
    final audiops = state.copyWith(
      roster: roster,
      player: AudioPlayer(),
    );

    onDurationSubscription =
        audiops.player?.durationStream.listen(_onDurationChanged);

    onPositionSubscription =
        audiops.player?.positionStream.listen(_onPositionChanged);

    onBufferedPositionSubscription = audiops.player?.bufferedPositionStream
        .listen(_onBufferedPositionChanged);

    onPlayingSubscription =
        audiops.player?.playingStream.listen(_onPlayingChanged);

    onProcessingStateSubscription =
        audiops.player?.processingStateStream.listen(_onProcessingStateChanged);

    emit(audiops);

    playRandomTrack();
  }

  void playTrack(Track track, [int? trackIndex]) async {
    final url = _findTrackUrl(track);
    if (url == null) return;
    final uri = Uri.parse(url);

    final audiops =
        state.copyWith(currentTrack: track, currentTrackIndex: trackIndex);

    emit(audiops);

    await audiops.player?.setAudioSource(
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
    await audiops.player?.play();
  }

  String? _findTrackUrl(Track track) {
    if (state.roster == null) return null;
    final roster = state.roster!;
    final url = '${roster.url}/${track.file}.${roster.ext}';
    return url;
  }

  void pause() async {
    await state.player?.pause();
  }

  void play() async {
    if (state.currentTrack == null) {
      playRandomTrack();
    } else {
      await state.player?.play();
    }
  }

  void playRandomTrack() {
    final numTracks = state.roster?.tracks.length ?? 0;

    final next = Random.secure().nextInt(numTracks);

    playTrack(state.roster!.tracks[next], next);
  }

  void seek(Duration? d) {
    state.player?.seek(d);
  }

  void playPrevious() {
    final numTracks = state.roster?.tracks.length ?? 0;

    if (state.currentTrackIndex == null) return;
    final prev = (state.currentTrackIndex! - 1).clamp(0, numTracks);

    playTrack(state.roster!.tracks[prev], prev);
  }

  void playNext() {
    final numTracks = state.roster?.tracks.length ?? 0;

    if (state.currentTrackIndex == null) return;
    final prev = (state.currentTrackIndex! + 1).clamp(0, numTracks);

    playTrack(state.roster!.tracks[prev], prev);
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
    state.player?.dispose();
    onDurationSubscription?.cancel();
    onPositionSubscription?.cancel();
    onBufferedPositionSubscription?.cancel();
    onPlayingSubscription?.cancel();
    onProcessingStateSubscription?.cancel();

    return super.close();
  }
}
