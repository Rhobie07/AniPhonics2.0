import 'package:flutter/material.dart';

import '../audio/app_audio.dart';

class SoundControls extends StatelessWidget {
  const SoundControls({super.key, this.helpAsset});

  final String? helpAsset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (helpAsset != null)
          IconButton(
            tooltip: 'Help voice',
            onPressed: () {
              audioService.playAsset(helpAsset!);
            },
            icon: const Icon(Icons.record_voice_over),
            color: colors.primary,
          ),
        ValueListenableBuilder<bool>(
          valueListenable: audioController.isMuted,
          builder: (context, isMuted, _) {
            return IconButton(
              tooltip: isMuted ? 'Unmute' : 'Mute',
              onPressed: audioController.toggleMute,
              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
              color: colors.primary,
            );
          },
        ),
      ],
    );
  }
}
