import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarn_calculator/core/constants/app_radius.dart';
import 'package:yarn_calculator/core/constants/colors.dart';

ThemeData buildBauhausTheme() {
  return ThemeData(
    useMaterial3: true,

    textTheme: GoogleFonts.bebasNeueTextTheme().copyWith(
      bodyLarge: GoogleFonts.montserrat(fontSize: 16),
      bodyMedium: GoogleFonts.montserrat(fontSize: 14),
      titleLarge: GoogleFonts.bebasNeue(fontSize: 28),
    ),

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: BauhausColors.primary,
      onPrimary: BauhausColors.white,
      secondary: BauhausColors.secondary,
      onSecondary: BauhausColors.white,
      surface: BauhausColors.surface,
      onSurface: BauhausColors.black,
      error: Colors.red,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: BauhausColors.background,

    appBarTheme: const AppBarTheme(
      backgroundColor: BauhausColors.red,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BauhausColors.yellow,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(letterSpacing: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.heavy),
        ),
      ),
    ),

    cardTheme: CardTheme(
      color: BauhausColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.strong),
      ),
    ),

    listTileTheme: ListTileThemeData(
      tileColor: BauhausColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.strong),
      ),
    ),
  );
}
