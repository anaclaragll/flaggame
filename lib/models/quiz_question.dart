import 'country.dart';

class QuizQuestion {
  final Country answer;
  final List<Country> options;

  const QuizQuestion({
    required this.answer,
    required this.options,
  });
}
