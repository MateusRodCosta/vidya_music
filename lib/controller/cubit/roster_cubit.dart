import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vidya_music/model/roster.dart';
import 'package:http/http.dart' as http;

part 'roster_state.dart';

class RosterCubit extends Cubit<RosterState> {
  RosterCubit() : super(RosterInitial()) {
    fetchRoster();
  }

  void fetchRoster() async {
    try {
      emit(RosterLoading());
      final r =
          await http.read(Uri.parse('https://www.vipvgm.net/roster.min.json'));
      final js = jsonDecode(r);
      final roster = Roster.fromJson(js);
      emit(RosterSuccess(roster));
    } catch (e) {
      emit(RosterError());
    }
  }
}
