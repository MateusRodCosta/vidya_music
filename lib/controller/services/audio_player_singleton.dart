import 'package:just_audio/just_audio.dart';

class AudioPlayerSingleton {
  AudioPlayerSingleton._internal();

  static AudioPlayer? _audioPlayer;

  static AudioPlayer get instance {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }
}
