import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/audio/app_audio.dart';
import '../../../core/progress/progress_store.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/sound_controls.dart';
import 'puzzle_animal.dart';
import 'puzzle_difficulty.dart';

class PuzzlePlayArgs {
  const PuzzlePlayArgs({required this.animal, required this.difficulty});

  final PuzzleAnimal animal;
  final PuzzleDifficulty difficulty;
}

class PuzzlePlayScreen extends StatefulWidget {
  const PuzzlePlayScreen({super.key});

  @override
  State<PuzzlePlayScreen> createState() => _PuzzlePlayScreenState();
}

class _PuzzlePlayScreenState extends State<PuzzlePlayScreen> {
  static const int _size = 3;
  final Random _random = Random();
  late List<int> _tiles;
  late PuzzleAnimal _animal;
  late PuzzleDifficulty _difficulty;
  int _moves = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PuzzlePlayArgs) {
      _animal = args.animal;
      _difficulty = args.difficulty;
    } else if (args is PuzzleAnimal) {
      _animal = args;
      _difficulty = PuzzleDifficulty.easy;
    } else {
      _animal = const PuzzleAnimal(name: 'Cat', keyName: 'cat');
      _difficulty = PuzzleDifficulty.easy;
    }
    _shuffle();
    audioService.playAsset('assets/audio/puzzle_voice.mp3');
  }

  @override
  void dispose() {
    audioService.stop();
    super.dispose();
  }

  void _shuffle() {
    _tiles = List<int>.generate(_size * _size, (index) => index);
    final moves = puzzleDifficultyConfigs[_difficulty]?.shuffleMoves ?? 20;
    for (int i = 0; i < moves; i++) {
      _applyRandomMove();
    }
    _moves = 0;
    setState(() {});
  }

  void _applyRandomMove() {
    final emptyIndex = _tiles.indexOf(_size * _size - 1);
    final neighbors = _adjacentIndexes(emptyIndex);
    final swapIndex = neighbors[_random.nextInt(neighbors.length)];
    final temp = _tiles[swapIndex];
    _tiles[swapIndex] = _tiles[emptyIndex];
    _tiles[emptyIndex] = temp;
  }

  List<int> _adjacentIndexes(int index) {
    final row = index ~/ _size;
    final col = index % _size;
    final neighbors = <int>[];
    if (row > 0) neighbors.add(index - _size);
    if (row < _size - 1) neighbors.add(index + _size);
    if (col > 0) neighbors.add(index - 1);
    if (col < _size - 1) neighbors.add(index + 1);
    return neighbors;
  }

  bool _isSolved(List<int> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }

  void _move(int index) {
    final emptyIndex = _tiles.indexOf(_size * _size - 1);
    final canMove = _isAdjacent(index, emptyIndex);
    if (!canMove) return;
    setState(() {
      final temp = _tiles[index];
      _tiles[index] = _tiles[emptyIndex];
      _tiles[emptyIndex] = temp;
      _moves += 1;
    });

    audioService.playAsset('assets/audio/click.wav');

    if (_isSolved(_tiles)) {
      audioService.playAsset('assets/audio/win_game.mp3');
      _showSolvedDialog();
    }
  }

  bool _isAdjacent(int a, int b) {
    final rowA = a ~/ _size;
    final colA = a % _size;
    final rowB = b ~/ _size;
    final colB = b % _size;
    final rowDiff = (rowA - rowB).abs();
    final colDiff = (colA - colB).abs();
    return (rowDiff + colDiff) == 1;
  }

  void _showSolvedDialog() {
    final difficultyKey = _difficulty.name;
    ProgressStore.instance.setPuzzleComplete(_animal.keyName, difficultyKey);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Puzzle solved!'),
          content: Text('Solved in $_moves moves.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _shuffle();
              },
              child: const Text('Play again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPreview();
              },
              child: const Text('Preview'),
            ),
          ],
        );
      },
    );
  }

  void _showPreview() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Image.asset(
            'assets/images/${_animal.keyName}_puzzle.png',
            fit: BoxFit.contain,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('${_animal.name} Puzzle'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/puzzle_voice.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Text(
                'Slide tiles to complete the picture',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                '${puzzleDifficultyConfigs[_difficulty]?.label} • Moves: $_moves',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _tiles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _size,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                    itemBuilder: (context, index) {
                      final tile = _tiles[index];
                      final isEmpty = tile == _size * _size - 1;
                      return InkWell(
                        onTap: isEmpty ? null : () => _move(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color:
                                isEmpty
                                    ? Colors.transparent
                                    : Colors.white.withValues(alpha: 0.96),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isEmpty
                                      ? Colors.transparent
                                      : colors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child:
                              isEmpty
                                  ? const SizedBox.shrink()
                                  : Image.asset(
                                    'assets/images/${_animal.keyName}_${tile + 1}.png',
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _shuffle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.shuffle),
                label: const Text('Shuffle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
