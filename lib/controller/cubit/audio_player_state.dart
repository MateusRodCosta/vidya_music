part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  const AudioPlayerState({
    this.isPlaying,
    this.isShuffle,
    this.isLoopTrack,
    this.currentTrack,
    this.trackDuration,
    this.trackBuffered,
    this.trackPosition,
    this.currentTrackIndex,
  });

  final Track? currentTrack;
  final int? currentTrackIndex;

  final Duration? trackDuration;
  final Duration? trackBuffered;
  final Duration? trackPosition;

  final bool? isPlaying;
  final bool? isShuffle;
  final bool? isLoopTrack;

  AudioPlayerState copyWith({
    Track? currentTrack,
    int? currentTrackIndex,
    Duration? trackDuration,
    Duration? trackBuffered,
    Duration? trackPosition,
    bool? isPlaying,
    bool? isShuffle,
    bool? isLoopTrack,
  }) =>
      AudioPlayerState(
        currentTrack: currentTrack ?? this.currentTrack,
        currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
        trackDuration: trackDuration ?? this.trackDuration,
        trackBuffered: trackBuffered ?? this.trackBuffered,
        trackPosition: trackPosition ?? this.trackPosition,
        isPlaying: isPlaying ?? this.isPlaying,
        isShuffle: isShuffle ?? this.isShuffle,
        isLoopTrack: isLoopTrack ?? this.isLoopTrack,
      );

  @override
  List<Object?> get props => [
        currentTrack,
        currentTrackIndex,
        trackDuration,
        trackBuffered,
        trackPosition,
        isPlaying,
        isShuffle,
        isLoopTrack,
      ];

  @override
  bool get stringify => true;
}
