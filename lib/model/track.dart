class Track {
  final int id;
  final String game;
  final String title;
  final String comp;
  final String? arr;
  final String file;
  final bool hasSource;
  final bool isSrcTrack;

  Track(
    this.id,
    this.game,
    this.title,
    this.comp,
    this.arr,
    this.file,
    this.hasSource,
    this.isSrcTrack,
  );

  Track.fromJson(Map<String, dynamic> json, {bool getSource = false})
      : id = !getSource ? json['id'] : (json['s_id'] ?? json['id']),
        game = json['game'],
        title = !getSource ? json['title'] : (json['s_title'] ?? json['title']),
        comp = json['comp'],
        arr = !getSource ? json['arr'] : null,
        file = !getSource ? json['file'] : (json['s_file'] ?? json['file']),
        hasSource = json['s_id'] != null,
        isSrcTrack = getSource && json['s_id'] != null;
}
