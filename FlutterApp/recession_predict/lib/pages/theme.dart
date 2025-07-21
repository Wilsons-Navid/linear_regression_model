import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2E5BFF);
  static const Color secondaryColor = Color(0xFF8C54FF);
  static const Color accentColor = Color(0xFF00C1D4);
  static const Color darkColor = Color(0xFF1A1D1F);
  static const Color lightColor = Color(0xFFF4F5F6);
  static const Color successColor = Color(0xFF2ED47A);
  static const Color warningColor = Color(0xFFFFB946);
  static const Color dangerColor = Color(0xFFF7685B);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightColor,
        background: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkColor),
        titleTextStyle: TextStyle(
          color: darkColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  static Gradient get primaryGradient {
    return const LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
