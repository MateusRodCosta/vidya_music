class Playlist {
  Playlist(
    this.id,
    this.order,
    this.name,
    this.description,
    this.url,
    this.isSource,
    this.extras,
  );

  Playlist.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        order = json['order'],
        name = json['name'],
        description = json['description'],
        url = json['url'],
        isSource = json['is_source'] ?? false,
        extras = json['extras'] != null
            ? PlaylistExtras.fromJson(json['extras'])
            : null;

  final String id;
  final int order;
  final String name;
  final String description;
  final String url;
  final bool isSource;
  final PlaylistExtras? extras;
}

class PlaylistExtras {
  PlaylistExtras(
    this.sourcePath,
  );

  PlaylistExtras.fromJson(Map<String, dynamic> json)
      : sourcePath = json['source_path'];
  final String? sourcePath;
}
