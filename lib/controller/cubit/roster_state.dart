part of 'roster_cubit.dart';

@immutable
abstract class RosterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RosterInitial extends RosterState {
  @override
  List<Object?> get props => [];
}

class RosterLoading extends RosterState {
  @override
  List<Object?> get props => [];
}

class RosterSuccess extends RosterState {
  RosterSuccess(this.roster);

  final Roster roster;

  @override
  List<Object?> get props => [
        roster,
      ];
}

class RosterError extends RosterState {
  @override
  List<Object?> get props => [];
}
