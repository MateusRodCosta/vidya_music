import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vidya_music/core/utils/utils.dart';
import 'package:vidya_music/features/playlist/domain/entities/track.dart';

class AudioPlayerService {
  AudioPlayerService() {
    // ignore: discarded_futures
    _init();
  }

  final _audioPlayer = AudioPlayer();
  Uri? _playerArtUri;

  Future<void> _init() async {
    await _setupArt();
  }

  Future<void> _setupArt() async {
    _playerArtUri = await getPlayerArtFromAssets();
  }

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get bufferedStream => _audioPlayer.bufferedPositionStream;
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;

  Future<void> setPlaylist(List<Track> tracks) async {
    final audioSources = tracks
        .map(
          (track) => AudioSource.uri(
            track.uri,
            tag: MediaItem(
              id: '${track.id}',
              title: track.title,
              artist: track.game,
              artUri: _playerArtUri,
            ),
          ),
        )
        .toList();

    await _audioPlayer.setAudioSources(
      audioSources,
      shuffleOrder: DefaultShuffleOrder(),
    );
    await _audioPlayer.setShuffleModeEnabled(true);
    await _audioPlayer.seekToNext();
  }

  Future<void> play() async => _audioPlayer.play();
  Future<void> pause() async => _audioPlayer.pause();

  Future<void> seek(Duration? d, {int? index}) async =>
      _audioPlayer.seek(d, index: index);

  Future<void> seekToNext() async => _audioPlayer.seekToNext();
  Future<void> seekToPrevious() async => _audioPlayer.seekToPrevious();

  Future<void> setShuffle({required bool shuffleMode}) async =>
      _audioPlayer.setShuffleModeEnabled(shuffleMode);
  Future<void> setLoopTrack({required bool loopTrack}) async =>
      _audioPlayer.setLoopMode(loopTrack ? LoopMode.one : LoopMode.off);

  Future<void> seekToIndex(int index) async {
    if (_audioPlayer.audioSource != null &&
        index >= 0 &&
        index < _audioPlayer.audioSources.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
    }
  }

  void dispose() {
    // ignore: discarded_futures
    _audioPlayer.dispose();
  }
}
