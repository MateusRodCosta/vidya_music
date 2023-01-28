part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  final bool? playing;

  final Track? currentTrack;

  final Duration? trackDuration;
  final Duration? trackBuffered;
  final Duration? trackPosition;

  final int? currentTrackIndex;

  const AudioPlayerState({
    this.playing,
    this.currentTrack,
    this.trackDuration,
    this.trackBuffered,
    this.trackPosition,
    this.currentTrackIndex,
  });

  AudioPlayerState copyWith({
    bool? playing,
    Track? currentTrack,
    Duration? trackDuration,
    Duration? trackBuffered,
    Duration? trackPosition,
    int? currentTrackIndex,
  }) =>
      AudioPlayerState(
        playing: playing ?? this.playing,
        currentTrack: currentTrack ?? this.currentTrack,
        trackDuration: trackDuration ?? this.trackDuration,
        trackBuffered: trackBuffered ?? this.trackBuffered,
        trackPosition: trackPosition ?? this.trackPosition,
        currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      );

  @override
  List<Object?> get props => [
        playing,
        currentTrack,
        trackDuration,
        trackBuffered,
        trackPosition,
        currentTrackIndex,
      ];

  @override
  bool get stringify => true;
}
