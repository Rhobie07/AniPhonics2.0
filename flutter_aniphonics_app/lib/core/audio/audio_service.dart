import 'package:just_audio/just_audio.dart';

import 'audio_controller.dart';

class AudioService {
  AudioService({required this.audioController}) {
    audioController.isMuted.addListener(() {
      if (audioController.isMuted.value) {
        stop();
      }
    });
  }

  final AudioController audioController;
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAsset(String assetPath, {bool loop = false}) async {
    if (audioController.isMuted.value) return;
    await _player.stop();
    await _player.setAsset(assetPath);
    _player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
