import 'package:flutter/material.dart';

import 'models/game_config.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<void> quiz(GameConfig config) {
    return MaterialPageRoute<void>(
      builder: (_) => QuizScreen(config: config),
    );
  }

  static Route<int> settings(int duration) {
    return MaterialPageRoute<int>(
      builder: (_) => SettingsScreen(initial: duration),
    );
  }

  static Route<void> result({
    required int score,
    required int answered,
    required GameConfig config,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ResultScreen(
        score: score,
        answered: answered,
        config: config,
      ),
    );
  }
}
