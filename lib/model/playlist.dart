class Playlist {
  String id;
  int order;
  String name;
  String description;
  String url;
  bool isDefault;
  bool isSource;
  String additionalPath;

  Playlist(
    this.id,
    this.order,
    this.name,
    this.description,
    this.url,
    this.isDefault,
    this.isSource,
    this.additionalPath,
  );

  Playlist.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        order = json['order'] ?? 0,
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        url = json['url'] ?? '',
        isDefault = json['isDefault'] ?? false,
        isSource = json['isSource'] ?? false,
        additionalPath = json['additionalPath'] ?? '';
}
