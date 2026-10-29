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
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C5CFC),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardThemeData(
          color: const Color(0xFFF4F2FF),
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
