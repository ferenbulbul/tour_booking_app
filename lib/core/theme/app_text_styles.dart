import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const headlineSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const textTheme = TextTheme(
    displaySmall: displaySmall,
    headlineSmall: headlineSmall,
    titleMedium: titleMedium,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
  );
}
