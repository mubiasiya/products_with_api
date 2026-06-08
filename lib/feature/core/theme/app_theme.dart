import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

 
  static const Color _primaryLight = Color.fromARGB(255, 124, 126, 208); // Indigo / Electric Violet
  static const Color _secondaryLight = Color(0xFF4F46E5); // Deep Indigo
  static const Color _backgroundLight = Color(
    0xFFF8FAFC,
  ); 
  static const Color _surfaceLight = Colors.white;
  static const Color _textPrimaryLight = Color(
    0xFF0F172A,
  ); 


  static const Color _primaryDark = Color(0xFF818CF8); 
  static const Color _secondaryDark = Color(0xFF6366F1); 
  static const Color _backgroundDark = Color(
    0xFF0F172A,
  ); 
  static const Color _surfaceDark = Color(0xFF1E293B); 
  static const Color _textPrimaryDark = Colors.black;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryLight,
      scaffoldBackgroundColor: _backgroundLight,

      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        secondary: _secondaryLight,
        background: _backgroundLight,
        surface: _surfaceLight,
        onPrimary: Colors.white,
        onBackground: _textPrimaryLight,
        onSurface: _textPrimaryLight,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _textPrimaryLight, size: 20),
        titleTextStyle: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded modern edges
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
          elevation: 2,
          shadowColor: _primaryLight.withOpacity(0.3), // Glowing shadow effect
        ),
      ),

      cardTheme: CardTheme(
        color: _surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: _primaryLight.withOpacity(0.08),
            width: 1.5,
          ), // Tinted border
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9), // Slate 100
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _primaryLight,
            width: 2,
          ), // Clear indicator
        ),
        hintStyle: TextStyle(
          color: _textPrimaryLight.withOpacity(0.4),
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryDark,
      scaffoldBackgroundColor: _backgroundDark,

      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        secondary: _secondaryDark,
        background: _backgroundDark,
        surface: _surfaceDark,
        onPrimary: _backgroundDark,
        onBackground: _textPrimaryDark,
        onSurface: _textPrimaryDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _textPrimaryDark, size: 20),
        titleTextStyle: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: _backgroundDark,
          disabledBackgroundColor: Colors.grey.shade800,
          disabledForegroundColor: Colors.grey.shade600,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
          elevation: 4,
          shadowColor: _primaryDark.withOpacity(0.2),
        ),
      ),

      cardTheme: CardTheme(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1.5),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B), // Slate 800
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        hintStyle: TextStyle(
          color: _textPrimaryDark.withOpacity(0.4),
          fontSize: 14,
        ),
      ),
    );
  }
}
