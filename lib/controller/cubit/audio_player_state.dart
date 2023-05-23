part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  final bool? playing;
  final bool? isShuffle;
  final bool? isLoopTrack;

  final Track? currentTrack;

  final Duration? trackDuration;
  final Duration? trackBuffered;
  final Duration? trackPosition;

  final int? currentTrackIndex;

  const AudioPlayerState({
    this.playing,
    this.isShuffle,
    this.isLoopTrack,
    this.currentTrack,
    this.trackDuration,
    this.trackBuffered,
    this.trackPosition,
    this.currentTrackIndex,
  });

  AudioPlayerState copyWith({
    bool? playing,
    bool? isShuffle,
    bool? isLoopTrack,
    Track? currentTrack,
    Duration? trackDuration,
    Duration? trackBuffered,
    Duration? trackPosition,
    int? currentTrackIndex,
  }) =>
      AudioPlayerState(
        playing: playing ?? this.playing,
        isShuffle: isShuffle ?? this.isShuffle,
        isLoopTrack: isLoopTrack ?? this.isLoopTrack,
        currentTrack: currentTrack ?? this.currentTrack,
        trackDuration: trackDuration ?? this.trackDuration,
        trackBuffered: trackBuffered ?? this.trackBuffered,
        trackPosition: trackPosition ?? this.trackPosition,
        currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      );

  @override
  List<Object?> get props => [
        playing,
        isShuffle,
        isLoopTrack,
        currentTrack,
        trackDuration,
        trackBuffered,
        trackPosition,
        currentTrackIndex,
      ];

  @override
  bool get stringify => true;
}
