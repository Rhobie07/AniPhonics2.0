enum PuzzleDifficulty { easy, normal, hard }

class PuzzleDifficultyConfig {
  const PuzzleDifficultyConfig({
    required this.label,
    required this.shuffleMoves,
  });

  final String label;
  final int shuffleMoves;
}

const Map<PuzzleDifficulty, PuzzleDifficultyConfig> puzzleDifficultyConfigs = {
  PuzzleDifficulty.easy: PuzzleDifficultyConfig(
    label: 'Easy',
    shuffleMoves: 20,
  ),
  PuzzleDifficulty.normal: PuzzleDifficultyConfig(
    label: 'Normal',
    shuffleMoves: 60,
  ),
  PuzzleDifficulty.hard: PuzzleDifficultyConfig(
    label: 'Hard',
    shuffleMoves: 120,
  ),
};
