import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/domain/entities/roster.dart';
import 'package:vidya_music/features/playlist/domain/repositories/roster_repository.dart';

class LoadRosterUseCase {

  LoadRosterUseCase(this._repository);

  final RosterRepository _repository;

  Future<Roster?> call(Playlist playlist) async {
    final roster = await _repository.getRoster(playlist);
    return roster;
  }
}
