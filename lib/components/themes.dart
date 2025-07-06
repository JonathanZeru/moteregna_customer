import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Theme Colors
  static const darkPrimaryColor = Color.fromARGB(87, 120, 23, 23); // Preserved red
  static const darkSecondaryColor = Color(0xFF009600); // Preserved green
  static const darkTertiaryColor = Color(0xFFCC4444); // Accent red
  static const darkBackgroundColor = Color(0xFF0A0E21); // Deep midnight blue
  static const darkSurfaceColor = Color(0xFF1A1F38); // Slightly lighter blue for cards
  
  // Light Theme Colors
  static const lightPrimaryColor = Color(0xFF781717); // Preserved red
  static const lightSecondaryColor = Color(0xFF009600); // Preserved green
  static const lightTertiaryColor = Color(0xFFAA3333); // Accent red
  static const lightBackgroundColor = Color(0xFFF8F9FA); // Light gray
  static const lightSurfaceColor = Color(0xFFFFFFFF); // White
  
  // Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBackgroundColor,
      primaryColor: darkPrimaryColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        tertiary: darkTertiaryColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimaryColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          side: const BorderSide(color: darkSecondaryColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkSecondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      iconTheme: const IconThemeData(
        color: darkPrimaryColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
        thickness: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkSecondaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: darkPrimaryColor,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return darkSecondaryColor;
          }
          return Colors.grey[700]!;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return darkSecondaryColor;
          }
          return Colors.grey[700]!;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return darkSecondaryColor.withOpacity(0.5);
          }
          return Colors.grey[800]!;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: darkPrimaryColor,
        linearTrackColor: Colors.white24,
      ),
    );
  }
  
  // Light Theme
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackgroundColor,
      primaryColor: lightPrimaryColor,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        tertiary: lightTertiaryColor,
        background: lightBackgroundColor,
        surface: lightSurfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimaryColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: lightSurfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimaryColor,
          side: const BorderSide(color: lightSecondaryColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      iconTheme: const IconThemeData(
        color: lightPrimaryColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black12,
        thickness: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightSecondaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurfaceColor,
        selectedItemColor: lightPrimaryColor,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightSurfaceColor,
        contentTextStyle: TextStyle(color: Colors.black87),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return lightSecondaryColor;
          }
          return Colors.grey[400]!;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return lightSecondaryColor;
          }
          return Colors.grey[400]!;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return lightSecondaryColor.withOpacity(0.5);
          }
          return Colors.grey[300]!;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: lightPrimaryColor,
        linearTrackColor: Colors.grey[200],
      ),
    );
  }
}

