import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class UIHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnack(context, message, AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _showSnack(context, message, AppColors.error);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnack(
      context,
      message,
      AppColors.info, // veya warning tanımlarsak değiştiririz
    );
  }

  static void showValidationErrors(BuildContext context, List<String> errors) {
    final fullText = errors.join("\n");
    _showSnack(context, fullText, AppColors.error);
  }

  static void _showSnack(BuildContext context, String text, Color background) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
