class Track {
  int id;
  String game;
  String title;
  String comp;
  String file;

  Track(this.id, this.game, this.title, this.comp, this.file);

  Track.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        game = json['game'],
        title = json['title'],
        comp = json['comp'],
        file = json['file'];
}
