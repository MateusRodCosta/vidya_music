class Track {
  int? id;
  String game;
  String title;
  String comp;
  String? arr;
  String file;

  Track(this.id, this.game, this.title, this.comp, this.arr, this.file);

  Track.fromJson(Map<String, dynamic> json, {bool isSource = false})
      : id = !isSource ? json['id'] : (json['s_id'] ?? json['id']),
        game = json['game'],
        title = !isSource ? json['title'] : (json['s_title'] ?? json['title']),
        comp = json['comp'],
        arr = !isSource ? json['arr'] : null,
        file = !isSource ? json['file'] : (json['s_file'] ?? json['file']);
}
