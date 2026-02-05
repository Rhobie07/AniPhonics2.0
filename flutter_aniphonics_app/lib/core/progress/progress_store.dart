import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore {
  ProgressStore._(this._prefs);

  static ProgressStore? _instance;
  static ProgressStore get instance => _instance!;

  final SharedPreferences _prefs;

  static Future<void> init() async {
    _instance = ProgressStore._(await SharedPreferences.getInstance());
  }

  bool isMemoryLevelComplete(int level) {
    return _prefs.getBool('memory_level_$level') ?? false;
  }

  Future<void> setMemoryLevelComplete(int level) {
    return _prefs.setBool('memory_level_$level', true);
  }

  int getMatchNameRounds() => _prefs.getInt('match_name_rounds') ?? 0;

  int getMatchSoundRounds() => _prefs.getInt('match_sound_rounds') ?? 0;

  Future<void> incrementMatchNameRounds() async {
    final current = getMatchNameRounds();
    await _prefs.setInt('match_name_rounds', current + 1);
  }

  Future<void> incrementMatchSoundRounds() async {
    final current = getMatchSoundRounds();
    await _prefs.setInt('match_sound_rounds', current + 1);
  }

  bool isPuzzleComplete(String animalKey, String difficultyKey) {
    return _prefs.getBool('puzzle_${animalKey}_$difficultyKey') ?? false;
  }

  Future<void> setPuzzleComplete(String animalKey, String difficultyKey) {
    return _prefs.setBool('puzzle_${animalKey}_$difficultyKey', true);
  }

  int getPuzzleCompletions() {
    return _prefs
        .getKeys()
        .where((key) => key.startsWith('puzzle_'))
        .where((key) => _prefs.getBool(key) ?? false)
        .length;
  }
}
