import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/roster_cubit.dart';
import 'package:vidya_music/model/roster.dart';

class RosterDropdown extends StatefulWidget {
  const RosterDropdown({super.key});

  @override
  State<RosterDropdown> createState() => _RosterDropdownState();
}

class _RosterDropdownState extends State<RosterDropdown> {
  RosterPlaylist? currentRoster;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RosterCubit, RosterState>(builder: (context, rs) {
      if (rs is RosterStateLoading) {
        currentRoster = rs.selectedRoster;
      }
      return DropdownButton<RosterPlaylist>(
        value: currentRoster ?? RosterPlaylist.vip,
        items: const [
          DropdownMenuItem(value: RosterPlaylist.vip, child: Text('VIP')),
          DropdownMenuItem(
            value: RosterPlaylist.mellow,
            child: Text('Mellow'),
          ),
          DropdownMenuItem(value: RosterPlaylist.exiled, child: Text('Exiled')),
        ],
        onChanged: (rp) async {
          await BlocProvider.of<RosterCubit>(context).setRoster(rp);
        },
      );
    });
  }
}
