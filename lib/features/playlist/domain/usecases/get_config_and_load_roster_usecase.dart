import 'package:vidya_music/core/utils/cubit_l10n_keys.dart';
import 'package:vidya_music/features/playlist/domain/entities/config.dart';
import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/domain/entities/roster.dart';
import 'package:vidya_music/features/playlist/domain/repositories/config_repository.dart';
import 'package:vidya_music/features/playlist/domain/repositories/roster_repository.dart';

class GetConfigAndLoadRosterUseCase {
  GetConfigAndLoadRosterUseCase(this._configRepository, this._rosterRepository);
  final ConfigRepository _configRepository;
  final RosterRepository _rosterRepository;

  Future<(Config, Playlist, Roster)> call() async {
    final config = await _configRepository.getConfig();
    if (config == null) {
      throw Exception(CubitL10nKeys.playlistConfigDecodingError);
    }

    final availablePlaylists = List<Playlist>.from(config.playlists)
      ..sort((a, b) => a.order.compareTo(b.order));
    final defaultPlaylist = availablePlaylists.singleWhere(
      (p) => p.id == config.defaultPlaylist,
      orElse: () => availablePlaylists.first,
    );

    final roster = await _rosterRepository.getRoster(defaultPlaylist);
    if (roster == null) {
      throw Exception(CubitL10nKeys.genericError);
    }
    return (config, defaultPlaylist, roster);
  }
}
