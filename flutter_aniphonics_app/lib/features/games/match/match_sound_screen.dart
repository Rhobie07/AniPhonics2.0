import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/audio/app_audio.dart';
import '../../../core/progress/progress_store.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/sound_controls.dart';
import '../../../data/animal.dart';
import '../../../data/animal_data.dart';

class MatchSoundScreen extends StatefulWidget {
  const MatchSoundScreen({super.key});

  @override
  State<MatchSoundScreen> createState() => _MatchSoundScreenState();
}

class _MatchSoundScreenState extends State<MatchSoundScreen> {
  final Random _random = Random();
  late List<Animal> _choices;
  late Animal _answer;
  bool _locked = false;
  int? _selectedIndex;
  int _attemptsLeft = 3;
  int _roundsCompleted = 0;

  @override
  void initState() {
    super.initState();
    _startRound();
    _roundsCompleted = ProgressStore.instance.getMatchSoundRounds();
    audioService.playAsset('assets/audio/match_sound_voice.mp3');
  }

  @override
  void dispose() {
    audioService.stop();
    super.dispose();
  }

  void _startRound() {
    final shuffled = List<Animal>.from(animals)..shuffle(_random);
    _choices = shuffled.take(3).toList();
    _answer = _choices[_random.nextInt(_choices.length)];
    _locked = false;
    _selectedIndex = null;
    _attemptsLeft = 3;
  }

  Future<void> _onGuess(int index) async {
    if (_locked) return;
    setState(() {
      _selectedIndex = index;
    });

    audioService.playAsset('assets/audio/click.wav');
    final isCorrect = _choices[index].id == _answer.id;
    if (isCorrect) {
      setState(() {
        _locked = true;
      });
      audioService.playAsset('assets/audio/correct.mp3');
    } else {
      _attemptsLeft -= 1;
    }

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    if (isCorrect) {
      await ProgressStore.instance.incrementMatchSoundRounds();
      if (!mounted) return;
      setState(() {
        _roundsCompleted = ProgressStore.instance.getMatchSoundRounds();
      });
      _showRoundDialog();
      return;
    }

    if (_attemptsLeft <= 0) {
      _showOutOfTriesDialog();
      return;
    }

    setState(() {
      _locked = false;
      _selectedIndex = null;
    });
  }

  void _showRoundDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Awesome!'),
          content: const Text('Want another round?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(_startRound);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showOutOfTriesDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Try again'),
          content: Text('The correct answer was ${_answer.name}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(_startRound);
              },
              child: const Text('New round'),
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
        title: const Text('Match Sound'),
        actions: const [
          SoundControls(helpAsset: 'assets/audio/match_sound_voice.mp3'),
        ],
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Text(
                'Listen and tap the correct animal',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.hearing, color: colors.primary, size: 54),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        audioService.playAsset(_answer.soundAudioAsset);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Play Sound'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Attempts left: $_attemptsLeft',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rounds completed: $_roundsCompleted',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: List.generate(_choices.length, (index) {
                    final animal = _choices[index];
                    final isCorrect = animal.id == _answer.id;
                    final showState = _selectedIndex == index;
                    Color? borderColor;
                    if (showState) {
                      borderColor =
                          isCorrect ? colors.secondary : colors.primary;
                    }
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 8,
                          right: index == _choices.length - 1 ? 0 : 8,
                        ),
                        child: InkWell(
                          onTap: () => _onGuess(index),
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: borderColor ?? Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: Image.asset(
                                        animal.imageAsset,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      animal.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                if (_selectedIndex == index)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Image.asset(
                                      isCorrect
                                          ? 'assets/images/correct_1.png'
                                          : 'assets/images/wrong_1.png',
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
