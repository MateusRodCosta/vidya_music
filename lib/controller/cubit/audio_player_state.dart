part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  final Roster? roster;

  final AudioPlayer? player;
  final bool? playing;

  final Track? currentTrack;

  final Duration? trackDuration;
  final Duration? trackBuffered;
  final Duration? trackPosition;

  final int? currentTrackIndex;

  const AudioPlayerState({
    this.roster,
    this.player,
    this.playing,
    this.currentTrack,
    this.trackDuration,
    this.trackBuffered,
    this.trackPosition,
    this.currentTrackIndex,
  });

  AudioPlayerState copyWith({
    Roster? roster,
    AudioPlayer? player,
    bool? playing,
    Track? currentTrack,
    Duration? trackDuration,
    Duration? trackBuffered,
    Duration? trackPosition,
    int? currentTrackIndex,
  }) =>
      AudioPlayerState(
        roster: roster ?? this.roster,
        player: player ?? this.player,
        playing: playing ?? this.playing,
        currentTrack: currentTrack ?? this.currentTrack,
        trackDuration: trackDuration ?? this.trackDuration,
        trackBuffered: trackBuffered ?? this.trackBuffered,
        trackPosition: trackPosition ?? this.trackPosition,
        currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      );

  @override
  List<Object?> get props => [
        roster,
        player,
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
