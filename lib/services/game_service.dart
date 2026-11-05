import 'dart:math';

import '../data/country_repository.dart';
import '../models/country.dart';
import '../models/game_config.dart';
import '../models/quiz_question.dart';

class GameService {
  final CountryRepository countryRepository;
  final Random _random;

  GameService({
    CountryRepository? countryRepository,
    Random? random,
  })  : countryRepository = countryRepository ?? const CountryRepository(),
        _random = random ?? Random();

  List<Country> loadPool(GameConfig config) {
    final pool = countryRepository.findByContinent(config.continent);
    return pool..shuffle(_random);
  }
  QuizQuestion createQuestion({
    required Country answer,
    required List<Country> allCountries,
  }) {
    final distractors = allCountries
        .where((country) => country.name != answer.name)//answer: resposta correta.
        .toList()
      ..shuffle(_random);
    final options = [answer, ...distractors.take(3)]..shuffle(_random);//distractors: alternativas incorretas. take(3): seleciona três alternativas incorretas.
    return QuizQuestion(answer: answer, options: options);//shuffle(): embaralha as quatro opções.
  }
}
