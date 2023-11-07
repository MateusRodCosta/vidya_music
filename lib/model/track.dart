class Track {
  Track(
    this.id,
    this.game,
    this.title,
    this.comp,
    this.arr,
    this.file, {
    this.hasSource = false,
    this.isSrcTrack = false,
  });

  Track.fromJson(Map<String, dynamic> json, {bool getSource = false})
      : id = (!getSource ? json['id'] : (json['s_id'] ?? json['id'])) as int?,
        game = json['game'] as String,
        title = (!getSource
            ? json['title']
            : (json['s_title'] ?? json['title'])) as String,
        comp = json['comp'] as String,
        arr = (!getSource ? json['arr'] : null) as String?,
        file = (!getSource ? json['file'] : (json['s_file'] ?? json['file']))
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
}
