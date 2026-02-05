import 'package:flutter/material.dart';

import '../../core/widgets/app_background.dart';
import '../../core/navigation/app_routes.dart';
import '../../data/animal.dart';
import 'animal_list_screen.dart';

class NamesSoundsScreen extends StatelessWidget {
  const NamesSoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Names & Sounds'),
        leading: IconButton(
          tooltip: 'Home',
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.start, (route) => false);
          },
          icon: const Icon(Icons.home_rounded),
        ),
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick a habitat',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _CategoryCard(
                      title: 'Farm',
                      subtitle: 'Cows, goats, chickens',
                      color: colors.primary,
                      icon: Icons.grass,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const AnimalListScreen(
                                  category: AnimalCategory.farm,
                                ),
                          ),
                        );
                      },
                    ),
                    _CategoryCard(
                      title: 'Forest',
                      subtitle: 'Bears, tigers, pandas',
                      color: colors.secondary,
                      icon: Icons.park,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const AnimalListScreen(
                                  category: AnimalCategory.forest,
                                ),
                          ),
                        );
                      },
                    ),
                    _CategoryCard(
                      title: 'Pets',
                      subtitle: 'Cats, dogs, birds',
                      color: colors.tertiary,
                      icon: Icons.home,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => const AnimalListScreen(
                                  category: AnimalCategory.pet,
                                ),
                          ),
                        );
                      },
                    ),
                    _CategoryCard(
                      title: 'Games',
                      subtitle: 'Memory, puzzles, match',
                      color: colors.primary.withValues(alpha: 0.9),
                      icon: Icons.extension,
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.games);
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
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
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 22,
              offset: const Offset(0, 12),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
