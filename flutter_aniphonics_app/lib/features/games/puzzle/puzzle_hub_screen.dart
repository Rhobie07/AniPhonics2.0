import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/progress/progress_store.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/sound_controls.dart';
import 'puzzle_animal.dart';
import 'puzzle_difficulty.dart';
import 'puzzle_play_screen.dart';

class PuzzleHubScreen extends StatelessWidget {
  const PuzzleHubScreen({super.key});

  static const List<PuzzleAnimal> _animals = [
    PuzzleAnimal(name: 'Cat', keyName: 'cat'),
    PuzzleAnimal(name: 'Dog', keyName: 'dog'),
    PuzzleAnimal(name: 'Cow', keyName: 'cow'),
    PuzzleAnimal(name: 'Duck', keyName: 'duck'),
    PuzzleAnimal(name: 'Hamster', keyName: 'hams'),
    PuzzleAnimal(name: 'Tiger', keyName: 'tiger'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Puzzle'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/puzzle_voice.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a puzzle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children:
                      _animals.map((animal) {
                        final store = ProgressStore.instance;
                        final easyDone = store.isPuzzleComplete(
                          animal.keyName,
                          PuzzleDifficulty.easy.name,
                        );
                        final normalDone = store.isPuzzleComplete(
                          animal.keyName,
                          PuzzleDifficulty.normal.name,
                        );
                        final hardDone = store.isPuzzleComplete(
                          animal.keyName,
                          PuzzleDifficulty.hard.name,
                        );
                        return _PuzzleCard(
                          name: animal.name,
                          color: colors.primary,
                          imageAsset: _previewFor(animal),
                          easyDone: easyDone,
                          normalDone: normalDone,
                          hardDone: hardDone,
                          onTap: () {
                            _showDifficultyPicker(context, animal);
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyPicker(BuildContext context, PuzzleAnimal animal) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${animal.name} Puzzle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...PuzzleDifficulty.values.map((difficulty) {
                final config = puzzleDifficultyConfigs[difficulty]!;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.tune),
                  title: Text(config.label),
                  subtitle: Text('${config.shuffleMoves} shuffle moves'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      AppRoutes.puzzlePlay,
                      arguments: PuzzlePlayArgs(
                        animal: animal,
                        difficulty: difficulty,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _previewFor(PuzzleAnimal animal) {
    if (animal.keyName == 'hams') {
      return 'assets/images/hamster_puzzle.png';
    }
    return 'assets/images/${animal.keyName}_puzzle.png';
  }
}

class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({
    required this.name,
    required this.imageAsset,
    required this.color,
    required this.onTap,
    required this.easyDone,
    required this.normalDone,
    required this.hardDone,
  });

  final String name;
  final String imageAsset;
  final Color color;
  final VoidCallback onTap;
  final bool easyDone;
  final bool normalDone;
  final bool hardDone;

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
          children: [
            Expanded(child: Image.asset(imageAsset, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Slide to solve',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DifficultyDot(label: 'E', done: easyDone),
                const SizedBox(width: 6),
                _DifficultyDot(label: 'N', done: normalDone),
                const SizedBox(width: 6),
                _DifficultyDot(label: 'H', done: hardDone),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyDot extends StatelessWidget {
  const _DifficultyDot({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: done ? colors.secondary : Colors.black.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 11,
          color: done ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
