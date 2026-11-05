import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class FlagGameApp extends StatelessWidget {
  const FlagGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flag Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C5CFC),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF10111A),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1E2B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
