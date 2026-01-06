import 'package:flutter/material.dart';

class AppTheme {
  static const Color sageGreen = Color(0xFF00B050);
  static const Color sageDark = Color(0xFF0D8C4E);
  static const Color sageLight = Color(0xFFF4F7EC);

  static ThemeData get sageTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sageGreen,
        background: sageLight,
      ),
      scaffoldBackgroundColor: sageLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: sageGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
