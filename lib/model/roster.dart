import 'package:vidya_music/model/track.dart';

class Roster {
  String changelog;
  String url;
  String ext;
  int? newId;
  List<Track> tracks;

  Roster(this.changelog, this.url, this.ext, this.newId, this.tracks);

  Roster.fromJson(Map<String, dynamic> json, {bool isSource = false})
      : changelog = json['changelog'],
        url = json['url'],
        ext = json['ext'],
        newId = json['new_id'],
        tracks = (json['tracks'] as List<dynamic>)
            .map((t) => Track.fromJson(t, isSource: isSource))
            .toList();
}

enum RosterPlaylist { vip, source, mellow, exiled }
