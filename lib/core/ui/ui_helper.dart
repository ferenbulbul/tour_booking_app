import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class UIHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnack(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showSnack(context, message, Colors.red);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnack(context, message, Colors.orangeAccent);
  }

  static void showValidationErrors(BuildContext context, List<String> errors) {
    final fullText = errors.join("\n");
    _showSnack(context, fullText, Colors.red);
  }

  static void _showSnack(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
