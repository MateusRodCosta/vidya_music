class Playlist {
  Playlist(
    this.id,
    this.order,
    this.name,
    this.description,
    this.url, {
    this.isSource = false,
    this.extras,
  });

  Playlist.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        order = json['order'] as int,
        name = json['name'] as String,
        description = json['description'] as String,
        url = json['url'] as String,
        isSource = (json['is_source'] ?? false) as bool,
        extras = json['extras'] != null
            ? PlaylistExtras.fromJson(json['extras'] as Map<String, dynamic>)
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
      : sourcePath = json['source_path'] as String?;

  final String? sourcePath;
}
