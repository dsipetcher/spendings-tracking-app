import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const seed = Color(0xFF275B84);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      primary: seed,
      secondary: const Color(0xFF38B6FF),
      background: const Color(0xFFF5F7FA),
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondary.withOpacity(.08),
        selectedColor: colorScheme.secondary,
        labelStyle: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      textTheme: _textTheme,
    );
  }

  static ThemeData dark() {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: const Color(0xFF4FC3F7),
      secondary: const Color(0xFF81D4FA),
      surface: const Color(0xFF1B2530),
      background: const Color(0xFF0F141A),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme:
          _textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  );
}
