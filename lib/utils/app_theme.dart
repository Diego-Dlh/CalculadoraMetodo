import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Define todos los colores y estilos de la aplicación.
/// Tema oscuro moderno con paleta morada/azul.
class AppTheme {
  // Paleta de colores principal
  static const Color primary = Color(0xFF7C5CBF);       // Morado principal
  static const Color primaryLight = Color(0xFF9B7FD4);   // Morado claro
  static const Color accent = Color(0xFF00E5CC);         // Cian/turquesa acento
  static const Color accentWarm = Color(0xFFFF6B6B);     // Rojo cálido (errores)
  static const Color success = Color(0xFF4CAF82);         // Verde éxito

  // Fondos
  static const Color background = Color(0xFF0D0F1E);     // Fondo principal oscuro
  static const Color surface = Color(0xFF151828);        // Superficie de tarjetas
  static const Color surfaceVariant = Color(0xFF1E2235); // Variante superficie
  static const Color surfaceBorder = Color(0xFF2A2D45);  // Borde de tarjetas

  // Texto
  static const Color textPrimary = Color(0xFFEEEFF5);    // Blanco suave
  static const Color textSecondary = Color(0xFF8A8FAD);  // Gris azulado

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C5CBF), Color(0xFF4A3F8C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1A1F3A), Color(0xFF0D0F1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: accentWarm,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.lato(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        titleLarge: GoogleFonts.lato(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: GoogleFonts.lato(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.lato(
          color: textSecondary,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.sourceCodePro(
          color: textSecondary,
          fontSize: 11,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black38,
        titleTextStyle: GoogleFonts.lato(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: surfaceBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentWarm, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentWarm, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF4A4F6A), fontSize: 13),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        errorStyle: const TextStyle(color: accentWarm, fontSize: 11),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: surfaceVariant,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primary.withValues(alpha: 0.3),
        labelStyle: GoogleFonts.sourceCodePro(
          color: textSecondary,
          fontSize: 12,
        ),
        side: const BorderSide(color: surfaceBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: surfaceBorder,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceVariant,
        contentTextStyle: GoogleFonts.lato(color: textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

