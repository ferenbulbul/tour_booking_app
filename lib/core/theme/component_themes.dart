import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class ComponentThemes {
  // BUTTON
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      textStyle: AppTextStyles.labelLarge,
    ),
  );

  // INPUT
  static final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.withOpacity(0.08),
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      borderSide: BorderSide.none,
    ),
  );

  // CARD
  static final cardTheme = CardThemeData(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.05),
    color: AppColors.surface,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
  );

  // CHIP
  static final chipTheme = ChipThemeData(
    backgroundColor: Colors.grey.withOpacity(0.1),
    selectedColor: AppColors.primary,
    labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
    secondaryLabelStyle: AppTextStyles.labelLarge,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
    ),
  );

  // BOTTOM NAV
  static final bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    selectedLabelStyle: AppTextStyles.labelLarge,
    unselectedLabelStyle: AppTextStyles.labelLarge,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );
}
