import 'package:just_audio/just_audio.dart';

class AudioPlayerSingleton {
  static AudioPlayer? _audioPlayer;

  static AudioPlayer get instance {
    if (_audioPlayer != null) {
      return _audioPlayer!;
    } else {
      _audioPlayer = AudioPlayer();
      return _audioPlayer!;
    }
  }
}
