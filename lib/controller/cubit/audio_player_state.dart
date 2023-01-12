part of 'audio_player_cubit.dart';

class AudioPlayerState extends Equatable {
  Roster? roster;

  AudioPlayer? player;
  PlayerState? playerState;

  Track? currentTrack;

  Duration? trackDuration;
  Duration? trackBuffered;
  Duration? trackPosition;

  int? currentTrackIndex;

  AudioPlayerState({
    this.roster,
    this.player,
    this.playerState,
    this.currentTrack,
    this.trackDuration,
    this.trackBuffered,
    this.trackPosition,
    this.currentTrackIndex,
  });

  AudioPlayerState copyWith({
    Roster? roster,
    AudioPlayer? player,
    PlayerState? playerState,
    Track? currentTrack,
    Duration? trackDuration,
    Duration? trackBuffered,
    Duration? trackPosition,
    int? currentTrackIndex,
  }) =>
      AudioPlayerState(
        roster: roster ?? this.roster,
        player: player ?? this.player,
        playerState: playerState ?? this.playerState,
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
        playerState,
        currentTrack,
        trackDuration,
        trackBuffered,
        trackPosition,
        currentTrackIndex,
      ];

  @override
  bool get stringify => true;
}
