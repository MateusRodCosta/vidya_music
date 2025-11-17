// ignore_for_file: one_member_abstracts

import 'package:vidya_music/features/playlist/domain/entities/track.dart';

abstract class TrackRepository {
  Future<List<Track>?> getTracks();
}
