import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    const bg = Color(0xE4000000);
    const surface = Color(0xFF161A23);
    const text = Color(0xFFE5E7EB);
    const accent = Color(0xFF60A5FA); // light blue
    const accent2 = Color(0xFF34D399); // mint
    const accent3 = Color(0xFFF472B6); // pink
    const accent4 = Color(0xFFFBBF24); // amber

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
        primary: accent,
        secondary: accent2,
        surface: surface,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: text),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: text),
        bodyMedium: TextStyle(color: text),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      useMaterial3: true,
    );
  }

  static const pastelYellow = Color(0xFFFFF9C4);
  static const pastelGreen = Color(0xFFC8E6C9);
  static const pastelPink = Color(0xFFF8BBD0);
  static const pastelBlue = Color(0xFFBBDEFB);
}
