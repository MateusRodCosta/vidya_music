import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vidya_music/features/playlist/domain/entities/playlist.dart';
import 'package:vidya_music/features/playlist/domain/entities/roster.dart';
import 'package:vidya_music/features/playlist/domain/repositories/roster_repository.dart';

class RosterRepositoryImpl extends RosterRepository {
  RosterRepositoryImpl();

  @override
  Future<Roster?> getRoster(Playlist playlist) async {
    final (url, isSource) = (playlist.url, playlist.isSource);
    return _fetchAndParseRoster(Uri.parse(url), isSource: isSource);
  }

  Future<Roster> _fetchAndParseRoster(Uri url, {bool isSource = false}) async {
    final r = await http.read(url);
    final js = json.decode(r) as Map<String, dynamic>;
    return Roster.fromJson(js, getSource: isSource);
  }
}
