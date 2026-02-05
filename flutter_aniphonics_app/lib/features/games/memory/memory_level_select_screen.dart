import 'package:flutter/material.dart';

import '../../../core/audio/app_audio.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/progress/progress_store.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/sound_controls.dart';

class MemoryLevelSelectScreen extends StatefulWidget {
  const MemoryLevelSelectScreen({super.key});

  @override
  State<MemoryLevelSelectScreen> createState() =>
      _MemoryLevelSelectScreenState();
}

class _MemoryLevelSelectScreenState extends State<MemoryLevelSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final store = ProgressStore.instance;
    final level1Done = store.isMemoryLevelComplete(1);
    final level2Done = store.isMemoryLevelComplete(2);
    final level3Done = store.isMemoryLevelComplete(3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Memory Levels'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/memory_voice.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick a level',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _LevelTile(
                level: 1,
                subtitle: '6 pairs',
                isUnlocked: true,
                isComplete: level1Done,
                onTap: () {
                  audioService.playAsset('assets/audio/click.wav');
                  Navigator.of(context).pushNamed(AppRoutes.memoryLevel1);
                },
              ),
              const SizedBox(height: 12),
              _LevelTile(
                level: 2,
                subtitle: '8 pairs',
                isUnlocked: level1Done,
                isComplete: level2Done,
                onTap: () {
                  if (!level1Done) {
                    _showLocked(context);
                    return;
                  }
                  audioService.playAsset('assets/audio/click.wav');
                  Navigator.of(context).pushNamed(AppRoutes.memoryLevel2);
                },
              ),
              const SizedBox(height: 12),
              _LevelTile(
                level: 3,
                subtitle: '8 pairs (fast)',
                isUnlocked: level2Done,
                isComplete: level3Done,
                onTap: () {
                  if (!level2Done) {
                    _showLocked(context);
                    return;
                  }
                  audioService.playAsset('assets/audio/click.wav');
                  Navigator.of(context).pushNamed(AppRoutes.memoryLevel3);
                },
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: colors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        level3Done
                            ? 'All memory levels complete!'
                            : 'Finish levels to unlock more.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocked(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complete the previous level to unlock.')),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.level,
    required this.subtitle,
    required this.isUnlocked,
    required this.isComplete,
    required this.onTap,
  });

  final int level;
  final String subtitle;
  final bool isUnlocked;
  final bool isComplete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isComplete ? colors.secondary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isUnlocked ? colors.primary : Colors.grey).withValues(
                  alpha: 0.18,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? Icons.memory : Icons.lock,
                color: isUnlocked ? colors.primary : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $level',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            if (isComplete)
              Icon(Icons.check_circle, color: colors.secondary)
            else
              Icon(
                isUnlocked ? Icons.chevron_right : Icons.lock,
                color: isUnlocked ? colors.primary : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
