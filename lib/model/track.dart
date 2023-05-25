class Track {
  int? id;
  String game;
  String title;
  String comp;
  String? arr;
  String file;
  bool? hasSrc;
  bool? isSrcTrack;

  Track(this.id, this.game, this.title, this.comp, this.arr, this.file,
      this.hasSrc);

  Track.fromJson(Map<String, dynamic> json, {bool isSrc = false})
      : id = !isSrc ? json['id'] : (json['s_id'] ?? json['id']),
        game = json['game'],
        title = !isSrc ? json['title'] : (json['s_title'] ?? json['title']),
        comp = json['comp'],
        arr = !isSrc ? json['arr'] : null,
        file = !isSrc ? json['file'] : (json['s_file'] ?? json['file']),
        hasSrc = json['s_id'] != null,
        isSrcTrack = isSrc && (json['s_id'] != null);
}
