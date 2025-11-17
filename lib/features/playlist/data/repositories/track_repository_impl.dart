import 'package:vidya_music/features/playlist/domain/entities/track.dart';
import 'package:vidya_music/features/playlist/domain/repositories/track_repository.dart';

class TrackRepositoryImpl extends TrackRepository {
  TrackRepositoryImpl();

  @override
  Future<List<Track>?> getTracks() async {
    return null;
  }
}
