import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Shared PIN input theme used across verification screens.
class PinThemeHelper {
  PinThemeHelper._();

  static PinTheme defaultTheme(BuildContext context) {
    final scheme = context.colors;

    return PinTheme(
      width: 52,
      height: 56,
      textStyle: AppTextStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(color: scheme.outline.withValues(alpha: 1)),
      ),
    );
  }

  static PinTheme focusedTheme(BuildContext context) {
    final scheme = context.colors;

    return PinTheme(
      width: 52,
      height: 56,
      textStyle: AppTextStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w400,
        color: scheme.primary,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(color: scheme.primary, width: 2),
      ),
    );
  }

  static Widget cursor(BuildContext context, {double height = 22}) {
    return Container(
      width: 2,
      height: height,
      color: context.colors.primary,
    );
  }
}
