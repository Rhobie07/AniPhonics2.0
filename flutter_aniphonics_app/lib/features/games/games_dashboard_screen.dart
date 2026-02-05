import 'package:flutter/material.dart';

import '../../core/progress/progress_store.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/sound_controls.dart';

class GamesDashboardScreen extends StatelessWidget {
  const GamesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final store = ProgressStore.instance;
    final memoryDone = [
      store.isMemoryLevelComplete(1),
      store.isMemoryLevelComplete(2),
      store.isMemoryLevelComplete(3),
    ];
    final memoryCount = memoryDone.where((done) => done).length;
    final puzzleCount = store.getPuzzleCompletions();
    final matchNameRounds = store.getMatchNameRounds();
    final matchSoundRounds = store.getMatchSoundRounds();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Progress'),
        actions: const [SoundControls()],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your achievements',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _ProgressCard(
                title: 'Memory Levels',
                value: '$memoryCount/3 complete',
                icon: Icons.memory,
                color: colors.primary,
              ),
              const SizedBox(height: 12),
              _ProgressCard(
                title: 'Puzzle Wins',
                value: '$puzzleCount solved',
                icon: Icons.extension,
                color: colors.secondary,
              ),
              const SizedBox(height: 12),
              _ProgressCard(
                title: 'Match Name',
                value: '$matchNameRounds rounds',
                icon: Icons.text_fields,
                color: colors.tertiary,
              ),
              const SizedBox(height: 12),
              _ProgressCard(
                title: 'Match Sound',
                value: '$matchSoundRounds rounds',
                icon: Icons.volume_up,
                color: colors.primary.withValues(alpha: 0.9),
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
                    Icon(Icons.emoji_events, color: colors.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        memoryCount == 3
                            ? 'Memory master! Keep exploring.'
                            : 'Play more to unlock achievements.',
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
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
