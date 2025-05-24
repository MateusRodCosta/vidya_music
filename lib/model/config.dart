import 'package:equatable/equatable.dart';
import 'package:vidya_music/model/playlist.dart';

class Config extends Equatable {
  const Config({required this.defaultPlaylist, required this.playlists});

  Config.fromJson(Map<String, dynamic> json)
    : defaultPlaylist = json['default_playlist'] as String,
      playlists =
          (json['playlists'] as List<dynamic>)
              .map((p) => Playlist.fromJson(p as Map<String, dynamic>))
              .toList();

  final String defaultPlaylist;
  final List<Playlist> playlists;

  @override
  List<Object?> get props => [defaultPlaylist, playlists];

  @override
  bool get stringify => true;
}
