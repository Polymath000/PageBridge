import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      primary: AppColors.lightPrimary,
    ),

    dividerColor: AppColors.lightBorder.withValues(alpha: 0.8),
    scaffoldBackgroundColor: AppColors.lightBackground,

    bottomAppBarTheme: BottomAppBarThemeData(
      color: AppColors.lightBorder,
      elevation: 8,
      shadowColor: AppColors.spaceBlack.withValues(alpha: 0.08),
      height: 64,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: AppColors.darkSurface, width: 1),
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightText,
      elevation: 0,
    ),

    cardTheme: const CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightText),
      titleLarge: TextStyle(color: AppColors.lightText),
      titleMedium: TextStyle(color: AppColors.lightText),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      primary: AppColors.darkPrimary,
    ),

    dividerColor: AppColors.lightBorder.withValues(alpha: 0.8),
    scaffoldBackgroundColor: AppColors.darkBackground,

    bottomAppBarTheme: BottomAppBarThemeData(
      color: AppColors.notionDark,
      elevation: 8,
      shadowColor: AppColors.black,
      height: 64,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(
            color: AppColors.lightBorder.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkText,
      elevation: 0,
    ),

    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      titleLarge: TextStyle(color: AppColors.darkText),
      titleMedium: TextStyle(color: AppColors.darkText),
    ),
  );
}
