import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material Design 3 테마 설정
class AppTheme {
  // Seed Color (기본 소스)
  static const Color _seedColor = Color(0xFF7C3AED); // 보라색
  
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      
      // Typography
      textTheme: _buildTextTheme(Brightness.light),
      
      // Component Themes
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 1,
        surfaceTintColor: _seedColor,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 3,
      ),
    );
  }
  
  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      
      textTheme: _buildTextTheme(Brightness.dark),
      
      // Same component themes as light theme
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 1,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 3,
      ),
    );
  }
  
  /// M3 Text Theme
  static TextTheme _buildTextTheme(Brightness brightness) {
    return GoogleFonts.notoSansTextTheme(
      TextTheme(
        displayLarge: const TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.12),
        displayMedium: const TextStyle(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.16),
        displaySmall: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.22),
        
        headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.25),
        headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.29),
        headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.33),
        
        titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0, height: 1.27),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 1.50),
        titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
        
        bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, height: 1.50),
        bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.43),
        bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.33),
        
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43),
        labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.33),
        labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.45),
      ).apply(
        bodyColor: brightness == Brightness.dark ? Colors.white : Colors.black,
        displayColor: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
    );
  }
}

