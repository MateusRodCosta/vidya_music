import 'package:equatable/equatable.dart';

class Track extends Equatable {
  const Track({
    required this.id,
    required this.game,
    required this.title,
    required this.comp,
    required this.arr,
    required this.file,
    this.hasSource = false,
    this.isSrcTrack = false,
  });

  Track.fromJson(Map<String, dynamic> json, {bool getSource = false})
    : id = (!getSource ? json['id'] : (json['s_id'] ?? json['id'])) as int?,
      game = json['game'] as String,
      title =
          (!getSource ? json['title'] : (json['s_title'] ?? json['title']))
              as String,
      comp = json['comp'] as String,
      arr = (!getSource ? json['arr'] : null) as String?,
      file =
          (!getSource ? json['file'] : (json['s_file'] ?? json['file']))
              as String,
      hasSource = json['s_id'] != null,
      isSrcTrack = getSource && json['s_id'] != null;

  final int? id;
  final String game;
  final String title;
  final String comp;
  final String? arr;
  final String file;
  final bool hasSource;
  final bool isSrcTrack;

  String get toFullTrackName =>
      arr != null ? '$game - $arr - $title' : '$game - $title';

  @override
  List<Object?> get props => [
    id,
    game,
    title,
    comp,
    arr,
    file,
    hasSource,
    isSrcTrack,
  ];

  @override
  bool get stringify => true;
}
