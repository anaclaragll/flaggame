import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/country.dart';
import '../models/game_config.dart';
import '../models/quiz_question.dart';
import '../services/game_service.dart';

class QuizController extends ChangeNotifier {
  final GameConfig config;
  final GameService gameService;
  final void Function()? onFinished;

  late List<Country> _pool;
  late QuizQuestion question;
  Timer? _timer;
  int remaining;
  int score = 0;
  int answered = 0;
  bool locked = false;
  String? selectedAnswer;
  bool? wasCorrect;
  bool _finished = false;

  QuizController({
    required this.config,
    GameService? gameService,
    this.onFinished,
  })  : gameService = gameService ?? GameService(),
        remaining = config.duration {
    _start();
  }

  double get progress => remaining / config.duration;
  Country get current => question.answer;
  List<Country> get options => question.options;
  bool get isFinished => _finished;

  void _start() {
    _pool = gameService.loadPool(config);
    _nextQuestion();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_finished) return;
    if (remaining <= 1) {
      remaining = 0;
      notifyListeners();
      finish();
      return;
    }
    remaining--;
    notifyListeners();
  }

  void _nextQuestion() {
    if (_pool.isEmpty) _pool = gameService.loadPool(config);
    final answer = _pool.removeLast();
    question = gameService.createQuestion(
      answer: answer,
      allCountries: gameService.countryRepository.findByContinent(null),
    );
    locked = false;
    selectedAnswer = null;
    wasCorrect = null;
  }

  void answer(Country answer) {
    if (locked || remaining == 0 || _finished) return;
    locked = true;
    selectedAnswer = answer.name;
    wasCorrect = answer.name == current.name;
    answered++;
    if (wasCorrect!) score++;
    notifyListeners();

    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (_finished || remaining == 0) return;
      _nextQuestion();
      notifyListeners();
    });
  }

  void finish() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    onFinished?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
