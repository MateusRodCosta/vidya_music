class Track {
  int? id;
  String game;
  String title;
  String comp;
  String? arr;
  String file;

  Track(this.id, this.game, this.title, this.comp, this.arr, this.file);

  Track.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        game = json['game'],
        title = json['title'],
        comp = json['comp'],
        arr = json['arr'],
        file = json['file'];
}
