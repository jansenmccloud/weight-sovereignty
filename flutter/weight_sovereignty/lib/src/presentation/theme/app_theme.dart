import 'package:flutter/material.dart';

abstract final class AppTheme {
  // custom colors
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.white12;
  static const Color white = Colors.white70;
  static const Color purple = Colors.deepPurple;
  static const Color yellow = Colors.yellowAccent;
  static const Color red = Colors.redAccent;
  static const Color green = Colors.greenAccent;

  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color accent = purple;

  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: base.copyWith(
        surface: surface,
        primary: accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
