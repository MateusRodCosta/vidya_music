// ignore_for_file: one_member_abstracts

import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';

abstract class PlaylistRepository {
  Future<Playlist?> getPlaylist();
}
