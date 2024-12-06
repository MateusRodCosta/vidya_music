import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';

class PlayerPlayPauseButton extends StatelessWidget {
  const PlayerPlayPauseButton({super.key, this.isMiniPlayer = false});

  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();
    final baseColor = Theme.of(context).colorScheme.tertiary;

    final playIcon = !isMiniPlayer ? Icons.play_circle : Icons.play_arrow;
    final pauseIcon = !isMiniPlayer ? Icons.pause_circle : Icons.pause;

    return BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
      selector: (state) => state.isPlaying,
      builder: (context, isPlaying) => IconButton(
        onPressed: () async => (isPlaying ?? false)
            ? audioPlayerCubit.pause()
            : audioPlayerCubit.play(),
        icon: Icon(
          (isPlaying ?? false) ? pauseIcon : playIcon,
        ),
        iconSize: !isMiniPlayer ? 72 : null,
        color: !isMiniPlayer ? baseColor : null,
      ),
    );
  }
}

class PlayerPreviousButton extends StatelessWidget {
  const PlayerPreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();

    return IconButton(
      onPressed: () async => audioPlayerCubit.playPrevious(),
      icon: const Icon(Icons.skip_previous),
      iconSize: 40,
    );
  }
}

class PlayerNextButton extends StatelessWidget {
  const PlayerNextButton({super.key, this.isMiniPlayer = false});

  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();

    return IconButton(
      onPressed: () async => audioPlayerCubit.playNext(),
      icon: const Icon(Icons.skip_next),
      iconSize: !isMiniPlayer ? 40 : null,
    );
  }
}

class PlayerShuffleButton extends StatelessWidget {
  const PlayerShuffleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();
    final defaultColor = Theme.of(context).colorScheme.onSecondaryContainer;
    final accentColor = Theme.of(context).colorScheme.tertiary;

    return BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
      selector: (state) => state.isShuffle,
      builder: (context, isShuffle) => IconButton(
        onPressed: () async => audioPlayerCubit.setShuffle(
          shuffleMode: !(isShuffle ?? true),
        ),
        icon: const Icon(Icons.shuffle),
        color: (isShuffle ?? true) ? accentColor : defaultColor,
      ),
    );
  }
}

class PlayerLoopButton extends StatelessWidget {
  const PlayerLoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerCubit = context.read<AudioPlayerCubit>();

    return BlocSelector<AudioPlayerCubit, AudioPlayerState, bool?>(
      selector: (state) => state.isLoopTrack,
      builder: (context, isLoopTrack) => IconButton(
        onPressed: () async => audioPlayerCubit.setLoopTrack(
          loopTrack: !(isLoopTrack ?? false),
        ),
        icon: Icon((isLoopTrack ?? false) ? Icons.repeat_one : Icons.repeat),
        color: (isLoopTrack ?? false)
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }
}
