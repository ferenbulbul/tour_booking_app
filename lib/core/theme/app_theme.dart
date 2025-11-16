import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/component_themes.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),

    textTheme: AppTextStyles.textTheme,

    elevatedButtonTheme: ComponentThemes.elevatedButtonTheme,
    inputDecorationTheme: ComponentThemes.inputTheme,
    cardTheme: ComponentThemes.cardTheme,
    chipTheme: ComponentThemes.chipTheme,
    bottomNavigationBarTheme: ComponentThemes.bottomNavTheme,
  );
}
