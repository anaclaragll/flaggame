import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final String playerName;
  final int score;

  const ScoreEntry({required this.playerName, required this.score});

  Map<String, Object> toJson() => {'name': playerName, 'score': score};

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      playerName: json['name'] as String? ?? 'Jogador',
      score: json['score'] as int? ?? 0,
    );
  }
}

class ScoreService {
  static const _scoresKey = 'scores';

  Future<List<ScoreEntry>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_scoresKey) ?? [];
    final entries = <ScoreEntry>[];

    for (final value in stored) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          entries.add(ScoreEntry.fromJson(decoded));
        } else {
          entries
              .add(ScoreEntry(playerName: 'Jogador', score: int.parse(value)));
        }
      } on FormatException {
        continue;
      }
    }

    entries.sort((a, b) => b.score.compareTo(a.score));
    return entries.take(10).toList();
  }

  Future<List<ScoreEntry>> saveScore({
    required String playerName,
    required int score,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getScores();
    entries.add(ScoreEntry(playerName: playerName.trim(), score: score));
    entries.sort((a, b) => b.score.compareTo(a.score));
    final topEntries = entries.take(10).toList();
    await prefs.setStringList(
      _scoresKey,
      topEntries.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
    return topEntries;
  }
}
