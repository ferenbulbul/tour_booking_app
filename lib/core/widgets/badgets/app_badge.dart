import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final String text;

  const AppBadge(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.06)
            : Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.12)
              : Colors.black.withOpacity(.08),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
