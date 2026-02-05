import 'package:flutter/foundation.dart';

class AudioController {
  AudioController({bool isMuted = false})
    : isMuted = ValueNotifier<bool>(isMuted);

  final ValueNotifier<bool> isMuted;

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }
}
