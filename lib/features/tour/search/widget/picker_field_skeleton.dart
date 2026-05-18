import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class PickerFieldSkeleton extends StatelessWidget {
  const PickerFieldSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.black.withOpacity(.07);

    final highlight = isDark
        ? Colors.white.withOpacity(.20)
        : Colors.black.withOpacity(.13);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1100),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withOpacity(.5)),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            const SizedBox(width: 12),

            // Label placeholder
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Arrow placeholder
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
