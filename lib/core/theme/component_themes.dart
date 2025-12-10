import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class ComponentThemes {
  // -------------------------------------------------------------
  // 🔥 ELEVATED BUTTON THEME — PrimaryButton dahil HER YERDE KULLANILIR
  // -------------------------------------------------------------
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.primary.withOpacity(0.4); // disabled
        }
        return AppColors.primary; // normal
      }),
      foregroundColor: WidgetStateProperty.all(Colors.white), // yazı/ikon
      overlayColor: WidgetStateProperty.all(
        AppColors.primaryDark.withOpacity(0.1),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16),
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
          color: Colors.white, // önemli
        ),
      ),
    ),
  );

  // -------------------------------------------------------------
  // 🔥 INPUT DECORATION (Login & Register aynı)
  // -------------------------------------------------------------
  static final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),

    // LABEL
    labelStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),

    // ICON
    prefixIconColor: AppColors.textSecondary,

    // BORDER
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
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );

  // -------------------------------------------------------------
  // 🔥 CARD
  // -------------------------------------------------------------
  static const cardTheme = CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shadowColor: Color(0x11000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
    ),
  );

  // -------------------------------------------------------------
  // 🔥 CHIP
  // -------------------------------------------------------------
  static final chipTheme = ChipThemeData(
    backgroundColor: Colors.black12,
    selectedColor: AppColors.primary,
    labelStyle: AppTextStyles.labelLarge,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.small),
    ),
  );

  // -------------------------------------------------------------
  // 🔥 SNACKBAR
  // -------------------------------------------------------------
  static final snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.surface,
    contentTextStyle: AppTextStyles.labelLarge.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
    elevation: 8,
  );

  // -------------------------------------------------------------
  // 🔥 BOTTOM NAVIGATION
  // -------------------------------------------------------------
  static final bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  );
}
