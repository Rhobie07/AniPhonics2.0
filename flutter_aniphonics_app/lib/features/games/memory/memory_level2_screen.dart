import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/audio/app_audio.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/progress/progress_store.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/sound_controls.dart';

class MemoryLevel2Screen extends StatefulWidget {
  const MemoryLevel2Screen({super.key});

  @override
  State<MemoryLevel2Screen> createState() => _MemoryLevel2ScreenState();
}

class _MemoryLevel2ScreenState extends State<MemoryLevel2Screen> {
  final List<String> _baseImages = const [
    'assets/images/front_card_cat1.png',
    'assets/images/front_card_dog1.png',
    'assets/images/front_card_cow1.png',
    'assets/images/front_card_goat1.png',
    'assets/images/front_card_duck1.png',
    'assets/images/front_card_lion1.png',
    'assets/images/front_card_monkey1.png',
    'assets/images/front_card_elephant1.png',
  ];

  late List<_CardModel> _cards;
  int? _firstIndex;
  bool _isBusy = false;
  int _matched = 0;

  @override
  void initState() {
    super.initState();
    _buildDeck();
    audioService.playAsset('assets/audio/memory_voice.mp3');
  }

  @override
  void dispose() {
    audioService.stop();
    super.dispose();
  }

  void _buildDeck() {
    final random = Random();
    final pairs = <_CardModel>[];
    for (final image in _baseImages) {
      pairs.add(_CardModel(image: image));
      pairs.add(_CardModel(image: image.replaceFirst('1.png', '2.png')));
    }
    pairs.shuffle(random);
    _cards = pairs;
    _matched = 0;
    _firstIndex = null;
    _isBusy = false;
  }

  Future<void> _onCardTap(int index) async {
    if (_isBusy) return;
    final card = _cards[index];
    if (card.isMatched || card.isFlipped) return;

    audioService.playAsset('assets/audio/click.wav');

    setState(() {
      card.isFlipped = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    _isBusy = true;
    final firstCard = _cards[_firstIndex!];
    if (_pairKey(firstCard.image) == _pairKey(card.image)) {
      firstCard.isMatched = true;
      card.isMatched = true;
      _matched += 2;
      audioService.playAsset('assets/audio/correct.mp3');
      _firstIndex = null;
      _isBusy = false;
      setState(() {});

      if (_matched == _cards.length) {
        audioService.playAsset('assets/audio/win_game.mp3');
        _showWinDialog();
      }
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      setState(() {
        firstCard.isFlipped = false;
        card.isFlipped = false;
      });
      _firstIndex = null;
      _isBusy = false;
    }
  }

  String _pairKey(String asset) {
    return asset.replaceFirst('1.png', '').replaceFirst('2.png', '');
  }

  Future<void> _showWinDialog() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    await ProgressStore.instance.setMemoryLevelComplete(2);
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Level 2 complete!'),
          content: const Text('Ready for the next level?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(_buildDeck);
              },
              child: Text(
                'Play again',
                style: TextStyle(color: colors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoutes.memoryLevel3);
              },
              child: Text('Level 3', style: TextStyle(color: colors.secondary)),
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
        title: const Text('Memory Level 2'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/memory_voice.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Match all the pairs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: _cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                card.isMatched
                                    ? colors.secondary
                                    : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          card.isFlipped || card.isMatched
                              ? card.image
                              : 'assets/images/back_card.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(_buildDeck);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Shuffle'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        audioService.playAsset('assets/audio/memory_voice.mp3');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Help'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardModel {
  _CardModel({required this.image});

  final String image;
  bool isFlipped = false;
  bool isMatched = false;
}
