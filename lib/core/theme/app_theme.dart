import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/component_themes.dart';

class AppTheme {
  // -------------------------------------------------------------
  // 🔆 LIGHT THEME
  // -------------------------------------------------------------
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,

      error: AppColors.error,
      onError: Colors.white,

      background: AppColors.background,
      onBackground: AppColors.textPrimary,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      surfaceVariant: AppColors.background,
      onSurfaceVariant: AppColors.textSecondary,

      outline: AppColors.border,
      outlineVariant: AppColors.border,

      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryDark,

      // Required
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimary,
      secondaryContainer: AppColors.surface,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.primaryLight,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.surface,
      onTertiaryContainer: AppColors.textPrimary,
      shadow: Colors.black,
      scrim: Colors.black,
    ),

    elevatedButtonTheme: ComponentThemes.elevatedButtonTheme,
    textTheme: AppTextStyles.textTheme,
    inputDecorationTheme: ComponentThemes.inputTheme,
    cardTheme: ComponentThemes.cardTheme,
    chipTheme: ComponentThemes.chipTheme,
    snackBarTheme: ComponentThemes.snackBarTheme,
    bottomNavigationBarTheme: ComponentThemes.bottomNavTheme,
  );

  // -------------------------------------------------------------
  // 🌙 DARK THEME
  // -------------------------------------------------------------
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0F0F0F),

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.primary,
      onPrimary: Colors.white,

      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,

      error: AppColors.error,
      onError: Colors.white,

      background: Color(0xFF0F0F0F),
      onBackground: Colors.white,

      surface: Color(0xFF1A1A1A),
      onSurface: Colors.white,

      surfaceVariant: Color(0xFF242424),
      onSurfaceVariant: Color(0xFFBBBBBB),

      outline: Color(0xFF3A3A3A),
      outlineVariant: Color(0xFF3A3A3A),

      inverseSurface: Colors.white,
      onInverseSurface: Colors.black,
      inversePrimary: AppColors.primaryLight,

      // Required fields
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: Colors.white,
      secondaryContainer: Color(0xFF1A1A1A),
      onSecondaryContainer: Colors.white,
      tertiary: AppColors.primaryLight,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF1A1A1A),
      onTertiaryContainer: Colors.white,

      shadow: Colors.black,
      scrim: Colors.black,
    ),

    textTheme: AppTextStyles.textTheme,

    inputDecorationTheme: ComponentThemes.inputTheme.copyWith(
      fillColor: const Color(0xFF1E1E1E),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: Color(0xFFBDBDBD)),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF888888)),
      prefixIconColor: Color(0xFF9E9E9E),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    snackBarTheme: ComponentThemes.snackBarTheme,
    cardTheme: ComponentThemes.cardTheme,
    chipTheme: ComponentThemes.chipTheme,
    bottomNavigationBarTheme: ComponentThemes.bottomNavTheme,
  );
}
