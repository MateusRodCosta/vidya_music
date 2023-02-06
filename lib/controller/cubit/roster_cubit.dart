import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:http/http.dart' as http;

part 'roster_state.dart';

class RosterCubit extends Cubit<RosterState> {
  RosterCubit() : super(RosterStateInitial()) {
    fetchRoster();
  }

  RosterPlaylist _selectedRoster = RosterPlaylist.vip;

  Future<void> setRoster(RosterPlaylist? playlist) async {
    if (playlist == null || playlist == _selectedRoster) return;
    _selectedRoster = playlist;
    await fetchRoster();
  }

  Future<void> fetchRoster() async {
    final url = _getPlayListUrl();
    try {
      emit(RosterStateLoading(_selectedRoster));
      final r = await http.read(Uri.parse(url));
      final js = jsonDecode(r);
      final roster = Roster.fromJson(js,
          isSource: _selectedRoster == RosterPlaylist.source);
      emit(RosterStateSuccess(_selectedRoster, roster));
    } catch (e) {
      emit(RosterStateError());
    }
  }

  String _getPlayListUrl() {
    switch (_selectedRoster) {
      case RosterPlaylist.mellow:
        return 'https://www.vipvgm.net/roster-mellow.min.json';
      case RosterPlaylist.exiled:
        return 'https://www.vipvgm.net/roster-exiled.min.json';
      default:
        return 'https://www.vipvgm.net/roster.min.json';
    }
  }
}
