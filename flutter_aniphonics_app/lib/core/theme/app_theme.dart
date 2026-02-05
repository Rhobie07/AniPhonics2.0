import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2C9AA1),
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF1D8B8E),
    secondary: const Color(0xFFF3A64F),
    tertiary: const Color(0xFF6FAE7C),
    surface: const Color(0xFFF8F4EF),
    onSurface: const Color(0xFF2C2A27),
    onPrimary: Colors.white,
    onSecondary: const Color(0xFF2C2A27),
    onTertiary: const Color(0xFF1F2A22),
  );

  static ThemeData get light {
    final base = ThemeData(colorScheme: _lightScheme, useMaterial3: true);

    final textTheme = GoogleFonts.fredokaTextTheme(base.textTheme).apply(
      bodyColor: _lightScheme.onSurface,
      displayColor: _lightScheme.onSurface,
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineLarge: GoogleFonts.fredoka(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: _lightScheme.onSurface,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _lightScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.fredoka(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _lightScheme.onSurface,
        ),
      ),
      scaffoldBackgroundColor: _lightScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightScheme.surface.withValues(alpha: 0.92),
        elevation: 0,
        foregroundColor: _lightScheme.onSurface,
        iconTheme: IconThemeData(color: _lightScheme.onSurface),
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.95),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
