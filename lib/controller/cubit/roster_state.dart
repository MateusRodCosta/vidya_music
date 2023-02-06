part of 'roster_cubit.dart';

@immutable
abstract class RosterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RosterStateInitial extends RosterState {
  @override
  List<Object?> get props => [];
}

class RosterStateLoading extends RosterState {
  RosterStateLoading(this.selectedRoster);

  final RosterPlaylist selectedRoster;

  @override
  List<Object?> get props => [selectedRoster];
}

class RosterStateSuccess extends RosterState {
  RosterStateSuccess(this.selectedRoster, this.roster);

  final RosterPlaylist selectedRoster;
  final Roster roster;

  @override
  List<Object?> get props => [selectedRoster, roster];
}

class RosterStateError extends RosterState {
  @override
  List<Object?> get props => [];
}
