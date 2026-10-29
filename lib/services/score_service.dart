import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const _scoresKey = 'scores';

  Future<List<int>> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores =
        prefs.getStringList(_scoresKey)?.map(int.parse).toList() ?? [];
    scores.add(score);
    scores.sort((a, b) => b.compareTo(a));
    final topScores = scores.take(5).toList();
    await prefs.setStringList(
      _scoresKey,
      topScores.map((value) => value.toString()).toList(),
    );
    return topScores;
  }
}
