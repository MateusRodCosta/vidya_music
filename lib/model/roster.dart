import 'track.dart';

class Roster {
  Roster(this.changelog, this.url, this.ext, this.newId, this.tracks);

  factory Roster.fromJson(Map<String, dynamic> json, {bool getSource = false}) {
    final changelog = json['changelog'];
    final url = json['url'];
    final ext = json['ext'];
    final newId = json['new_id'];
    final tracks = (json['tracks'] as List<dynamic>)
        .map((t) => Track.fromJson(t, getSource: getSource))
        .toList();

    return Roster(changelog, url, ext, newId, tracks);
  }

  final String changelog;
  final String url;
  final String ext;
  final int? newId;
  final List<Track> tracks;
}
