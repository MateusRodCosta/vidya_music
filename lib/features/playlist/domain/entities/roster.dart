import 'package:equatable/equatable.dart';
import 'package:vidya_music/features/playlist/domain/entities/track.dart';

class Roster extends Equatable {
  const Roster({
    required this.changelog,
    required this.url,
    required this.ext,
    required this.tracks,
    this.newId,
  });

  factory Roster.fromJson(Map<String, dynamic> json, {bool getSource = false}) {
    final changelog = json['changelog'] as String;
    final url = json['url'] as String;
    final ext = json['ext'] as String;
    final tracks = (json['tracks'] as List<dynamic>)
        .map(
          (t) => Track.fromJson(
            t as Map<String, dynamic>,
            getSource: getSource,
            url: url,
            ext: ext,
          ),
        )
        .toList();
    final newId = json['new_id'] as int?;

    return Roster(
      changelog: changelog,
      url: url,
      ext: ext,
      tracks: tracks,
      newId: newId,
    );
  }

  final String changelog;
  final String url;
  final String ext;
  final List<Track> tracks;
  final int? newId;

  @override
  List<Object?> get props => [changelog, url, ext, tracks, newId];

  @override
  bool get stringify => true;
}
