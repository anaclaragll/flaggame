import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../services/score_service.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int answered;
  final GameConfig config;

  const ResultScreen(
      {super.key,
      required this.score,
      required this.answered,
      required this.config});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScoreService _scoreService = ScoreService();
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    _saveScore();
  }

  Future<void> _saveScore() async {
    final savedScores = await _scoreService.saveScore(widget.score);
    if (mounted) setState(() => scores = savedScores);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.answered == 0
        ? 0
        : ((widget.score / widget.answered) * 100).round();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text('🏆', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 14),
              Text('Partida encerrada!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  widget.config.continent == null
                      ? 'Modo aleatório'
                      : widget.config.continent!,
                  style: const TextStyle(color: Colors.white60)),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                    child: _stat('Pontuação', '${widget.score}',
                        Icons.stars_rounded, const Color(0xFFFFC857))),
                Expanded(
                    child: _stat('Respondidas', '${widget.answered}',
                        Icons.quiz_rounded, const Color(0xFF6C63FF))),
                Expanded(
                    child: _stat('Acertos', '$percentage%', Icons.track_changes,
                        const Color(0xFF40D9A2)))
              ]),
              const SizedBox(height: 28),
              if (scores.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Melhores pontuações',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...scores.asMap().entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(children: [
                              Text('${entry.key + 1}.',
                                  style:
                                      const TextStyle(color: Colors.white54)),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(entry.key == 0
                                      ? 'Melhor resultado'
                                      : 'Partida anterior')),
                              Text('${entry.value} pts',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ]))),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Voltar ao menu'))),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  QuizScreen(config: widget.config))),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Jogar novamente'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 7),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 21)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.white54))
        ]),
      ),
    );
  }
}
