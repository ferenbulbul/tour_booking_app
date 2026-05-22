import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color baseBg;
    switch (difficulty.toLowerCase()) {
      case "kolay":
        baseBg = context.ext.difficultyEasy;
        break;
      case "orta":
        baseBg = context.ext.difficultyMedium;
        break;
      case "zor":
        baseBg = context.ext.difficultyHard;
        break;
      default:
        baseBg = context.colors.onSurfaceVariant;
    }

    final bg = isDark ? baseBg.withValues(alpha: 0.22) : baseBg.withValues(alpha: 0.14);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ms, vertical: AppSpacing.xsm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: baseBg.withValues(alpha: isDark ? 0.35 : 0.28)),
      ),
      child: Text(
        difficulty,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.onSurface,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
