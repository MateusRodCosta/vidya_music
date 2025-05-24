import 'package:equatable/equatable.dart';
import 'package:vidya_music/model/track.dart';

class Roster extends Equatable {
  const Roster({
    required this.changelog,
    required this.url,
    required this.ext,
    required this.tracks,
    this.newId,
  });

  Roster.fromJson(Map<String, dynamic> json, {bool getSource = false})
    : changelog = json['changelog'] as String,
      url = json['url'] as String,
      ext = json['ext'] as String,
      tracks =
          (json['tracks'] as List<dynamic>)
              .map(
                (t) => Track.fromJson(
                  t as Map<String, dynamic>,
                  getSource: getSource,
                ),
              )
              .toList(),
      newId = json['new_id'] as int?;

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
