import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class PickerFieldSkeleton extends StatelessWidget {
  const PickerFieldSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    final highlight = isDark
        ? Colors.white.withValues(alpha: 0.20)
        : Colors.black.withValues(alpha: 0.13);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1100),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ml),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(AppRadius.ml),
          border: Border.all(color: context.colors.outline.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),

            const SizedBox(width: AppSpacing.m),

            // Label placeholder
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.m),

            // Arrow placeholder
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
