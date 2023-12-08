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
  PlaylistStateLoading(this.availablePlaylists, this.selectedPlaylist);

  final List<Playlist> availablePlaylists;
  final Playlist selectedPlaylist;

  @override
  List<Object?> get props => [availablePlaylists, selectedPlaylist];
}

class PlaylistStateSuccess extends PlaylistState {
  PlaylistStateSuccess(
    this.availablePlaylists,
    this.selectedPlaylist,
    this.roster,
  );

  final List<Playlist> availablePlaylists;
  final Playlist selectedPlaylist;
  final Roster roster;

  @override
  List<Object?> get props => [availablePlaylists, selectedPlaylist, roster];
}

class PlaylistStateError extends PlaylistState {
  PlaylistStateError({
    this.errorMessage = LocaleKeys.genericError,
    this.availablePlaylists,
  });

  final String errorMessage;
  final List<Playlist>? availablePlaylists;

  @override
  List<Object?> get props => [errorMessage, availablePlaylists];
}
