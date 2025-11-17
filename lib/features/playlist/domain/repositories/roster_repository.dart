// ignore_for_file: one_member_abstracts

import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/domain/entities/roster.dart';

abstract class RosterRepository {
  Future<Roster?> getRoster(Playlist playlist);
}
