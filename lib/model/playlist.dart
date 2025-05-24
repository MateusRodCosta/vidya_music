import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  const Playlist({
    required this.id,
    required this.order,
    required this.name,
    required this.description,
    required this.url,
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
      extras =
          json['extras'] != null
              ? PlaylistExtras.fromJson(json['extras'] as Map<String, dynamic>)
              : null;

  final String id;
  final int order;
  final String name;
  final String description;
  final String url;
  final bool isSource;
  final PlaylistExtras? extras;

  @override
  List<Object?> get props => [
    id,
    order,
    name,
    description,
    url,
    isSource,
    extras,
  ];

  @override
  bool get stringify => true;
}

class PlaylistExtras extends Equatable {
  const PlaylistExtras({required this.sourcePath});

  PlaylistExtras.fromJson(Map<String, dynamic> json)
    : sourcePath = json['source_path'] as String?;

  final String? sourcePath;

  @override
  List<Object?> get props => [sourcePath];

  @override
  bool get stringify => true;
}
