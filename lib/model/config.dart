import 'package:vidya_music/model/playlist.dart';

class Config {
  Config(this.defaultPlaylist, this.playlists);

  Config.fromJson(Map<String, dynamic> json)
      : defaultPlaylist = json['default_playlist'] as String,
        playlists = (json['playlists'] as List<dynamic>)
            .map((p) => Playlist.fromJson(p as Map<String, dynamic>))
            .toList();

  String defaultPlaylist;
  List<Playlist> playlists;
}
