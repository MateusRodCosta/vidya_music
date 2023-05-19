part of 'playlist_cubit.dart';

@immutable
abstract class PlaylistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaylistStateInitial extends PlaylistState {
  @override
  List<Object?> get props => [];
}

class PlaylistStateDecoded extends PlaylistState {
  PlaylistStateDecoded(this.availablePlaylists);

  final List<Playlist> availablePlaylists;

  @override
  List<Object?> get props => [availablePlaylists];
}

class PlaylistStateLoading extends PlaylistState {
  PlaylistStateLoading(this.availablePlaylists, this.selectedRoster);

  final List<Playlist> availablePlaylists;
  final Playlist selectedRoster;

  @override
  List<Object?> get props => [availablePlaylists, selectedRoster];
}

class PlaylistStateSuccess extends PlaylistState {
  PlaylistStateSuccess(
      this.availablePlaylists, this.selectedRoster, this.roster);

  final List<Playlist> availablePlaylists;
  final Playlist selectedRoster;
  final Roster roster;

  @override
  List<Object?> get props => [availablePlaylists, selectedRoster, roster];
}

class PlaylistStateError extends PlaylistState {
  PlaylistStateError(this.availablePlaylists);

  final List<Playlist> availablePlaylists;

  @override
  List<Object?> get props => [availablePlaylists];
}
