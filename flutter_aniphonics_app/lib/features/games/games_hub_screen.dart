import 'package:flutter/material.dart';

import '../../core/audio/app_audio.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/sound_controls.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Games'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/sound_game.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Play & Learn',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    _GameCard(
                      title: 'Progress',
                      subtitle: 'See your wins',
                      color: colors.tertiary,
                      icon: Icons.emoji_events,
                      onTap: () {
                        audioService.playAsset('assets/audio/click.wav');
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.gamesDashboard);
                      },
                    ),
                    _GameCard(
                      title: 'Memory',
                      subtitle: 'Find matching pairs',
                      color: colors.primary,
                      icon: Icons.grid_4x4,
                      onTap: () {
                        audioService.playAsset('assets/audio/click.wav');
                        Navigator.of(context).pushNamed(AppRoutes.memoryHub);
                      },
                    ),
                    _GameCard(
                      title: 'Puzzle',
                      subtitle: 'Slide to solve',
                      color: colors.secondary,
                      icon: Icons.extension,
                      onTap: () {
                        audioService.playAsset('assets/audio/click.wav');
                        Navigator.of(context).pushNamed(AppRoutes.puzzleHub);
                      },
                    ),
                    _GameCard(
                      title: 'Match Name',
                      subtitle: 'Pick the right word',
                      color: colors.tertiary,
                      icon: Icons.text_fields,
                      onTap: () {
                        audioService.playAsset('assets/audio/click.wav');
                        Navigator.of(context).pushNamed(AppRoutes.matchName);
                      },
                    ),
                    _GameCard(
                      title: 'Match Sound',
                      subtitle: 'Guess the sound',
                      color: colors.primary.withValues(alpha: 0.9),
                      icon: Icons.volume_up,
                      onTap: () {
                        audioService.playAsset('assets/audio/click.wav');
                        Navigator.of(context).pushNamed(AppRoutes.matchSound);
                      },
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

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Spacer(),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
