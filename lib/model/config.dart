import 'playlist.dart';

class Config {
  String defaultPlaylist;
  List<Playlist> playlists;

  Config(this.defaultPlaylist, this.playlists);

  Config.fromJson(Map<String, dynamic> json)
      : defaultPlaylist = json['default_playlist'],
        playlists = (json['playlists'] as List<dynamic>)
            .map((p) => Playlist.fromJson(p))
            .toList();
}
