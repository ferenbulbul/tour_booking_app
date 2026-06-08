import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class AppBadge extends StatelessWidget {
  final String text;

  const AppBadge(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = context.colors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ms, vertical: AppSpacing.xsm),
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: onSurface.withValues(alpha: 0.10),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colors.onSurface,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
