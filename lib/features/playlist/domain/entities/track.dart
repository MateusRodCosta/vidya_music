import 'package:equatable/equatable.dart';

class Track extends Equatable {
  const Track({
    required this.id,
    required this.game,
    required this.title,
    required this.comp,
    required this.arr,
    required this.file,
    this.extras,
  });

  factory Track.fromJson(
    Map<String, dynamic> json, {
    bool getSource = false,
    String url = '',
    String ext = '',
  }) {
    final sId = json['s_id'] != null
        ? json['s_id'] is int
              ? json['s_id']
              : int.tryParse(json['s_id'] as String)
        : null;
    final id = (!getSource ? json['id'] : (sId ?? json['id'])) as int?;
    final game = json['game'] as String;
    final title =
        (!getSource ? json['title'] : (json['s_title'] ?? json['title']))
            as String;
    final comp = json['comp'] as String;
    final arr = (!getSource ? json['arr'] : null) as String?;
    final file =
        (!getSource ? json['file'] : (json['s_file'] ?? json['file']))
            as String;

    final extras = TrackExtras.fromJson(
      json,
      getSource: getSource,
      url: url,
      ext: ext,
    );

    return Track(
      id: id,
      game: game,
      title: title,
      comp: comp,
      arr: arr,
      file: file,
      extras: extras,
    );
  }

  final int? id;
  final String game;
  final String title;
  final String comp;
  final String? arr;
  final String file;
  final TrackExtras? extras;

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
    extras,
  ];

  @override
  bool get stringify => true;

  Uri get uri {
    final rosterUrl = extras?.url ?? '';
    final sourcePath = (extras?.isSrcTrack ?? false) ? 'source/' : '';
    final filename = '$file.${extras?.ext ?? ''}';

    final url = '$rosterUrl$sourcePath$filename';
    return Uri.parse(url);
  }
}

class TrackExtras {
  const TrackExtras({
    this.hasSource = false,
    this.isSrcTrack = false,
    this.url = '',
    this.ext = '',
  });

  TrackExtras.fromJson(
    Map<String, dynamic> json, {
    bool getSource = false,
    this.url = '',
    this.ext = '',
  }) : hasSource = json['s_id'] != null,
       isSrcTrack = getSource && json['s_id'] != null;

  final bool hasSource;
  final bool isSrcTrack;
  final String url;
  final String ext;
}
