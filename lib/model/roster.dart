import 'package:vidya_music/model/track.dart';

class Roster {
  String changelog;
  String url;
  String ext;
  int? newId;
  List<Track> tracks;

  Roster(this.changelog, this.url, this.ext, this.newId, this.tracks);

  Roster.fromJson(Map<String, dynamic> json)
      : changelog = json['changelog'],
        url = json['url'],
        ext = json['ext'],
        newId = json['new_id'],
        tracks = (json['tracks'] as List<dynamic>)
            .map((t) => Track.fromJson(t))
            .toList();
}

enum RosterPlaylist { vip, mellow, exiled }
