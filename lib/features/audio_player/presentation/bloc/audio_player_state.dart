part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  const AudioPlayerState({
    this.isPlaying = false,
    this.currentTrack,
    this.currentTrackIndex,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffered = Duration.zero,
    this.isShuffle = true,
    this.isLoopTrack = false,
  });

  final bool isPlaying;

  final Track? currentTrack;
  final int? currentTrackIndex;

  final Duration position;
  final Duration duration;
  final Duration buffered;

  final bool isShuffle;
  final bool isLoopTrack;

  AudioPlayerState copyWith({
    bool? isPlaying,
    Track? currentTrack,
    int? currentTrackIndex,
    Duration? position,
    Duration? duration,
    Duration? buffered,
    bool? isShuffle,
    bool? isLoopTrack,
  }) => AudioPlayerState(
    isPlaying: isPlaying ?? this.isPlaying,
    currentTrack: currentTrack ?? this.currentTrack,
    currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
    position: position ?? this.position,
    duration: duration ?? this.duration,
    buffered: buffered ?? this.buffered,
    isShuffle: isShuffle ?? this.isShuffle,
    isLoopTrack: isLoopTrack ?? this.isLoopTrack,
  );

  @override
  List<Object?> get props => [
    isPlaying,
    currentTrack,
    currentTrackIndex,
    position,
    duration,
    buffered,
    isShuffle,
    isLoopTrack,
  ];

  @override
  bool get stringify => true;
}
