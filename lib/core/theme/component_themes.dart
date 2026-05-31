import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class ComponentThemes {
  // -------------------------------------------------------------
  // ELEVATED BUTTON — CTA orange
  // -------------------------------------------------------------
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.accent.withValues(alpha: 0.4);
        }
        return AppColors.accent;
      }),
      foregroundColor: WidgetStateProperty.all(AppColors.white),
      overlayColor: WidgetStateProperty.all(
        AppColors.accentDark.withValues(alpha: 0.15),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: AppSpacing.l),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
      textStyle: WidgetStateProperty.all(
        AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );

  // -------------------------------------------------------------
  // INPUT DECORATION
  // -------------------------------------------------------------
  static final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lm, horizontal: AppSpacing.xl),

    labelStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textLight,
    ),

    prefixIconColor: AppColors.textSecondary,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
    ),
  );

  // -------------------------------------------------------------
  // CARD
  // -------------------------------------------------------------
  static const cardTheme = CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shadowColor: Color.fromRGBO(0, 0, 0, 0.067),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
    ),
  );

  // -------------------------------------------------------------
  // CHIP
  // -------------------------------------------------------------
  static final chipTheme = ChipThemeData(
    backgroundColor: AppColors.black.withValues(alpha: 0.12),
    selectedColor: AppColors.primary,
    labelStyle: AppTextStyles.labelLarge,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.small),
    ),
  );

  // -------------------------------------------------------------
  // SNACKBAR
  // -------------------------------------------------------------
  static final snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
  );

  // -------------------------------------------------------------
  // BOTTOM NAVIGATION
  // -------------------------------------------------------------
  static final bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.accent,
    unselectedItemColor: AppColors.textSecondary,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  );
}
