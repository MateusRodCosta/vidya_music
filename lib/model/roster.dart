import 'package:vidya_music/model/track.dart';

class Roster {
  Roster(this.changelog, this.url, this.ext, this.newId, this.tracks);

  factory Roster.fromJson(Map<String, dynamic> json, {bool getSource = false}) {
    final changelog = json['changelog'] as String;
    final url = json['url'] as String;
    final ext = json['ext'] as String;
    final newId = json['new_id'] as int?;
    final tracks = (json['tracks'] as List<dynamic>)
        .map(
          (t) =>
              Track.fromJson(t as Map<String, dynamic>, getSource: getSource),
        )
        .toList();

    return Roster(changelog, url, ext, newId, tracks);
  }

  final String changelog;
  final String url;
  final String ext;
  final int? newId;
  final List<Track> tracks;
}
