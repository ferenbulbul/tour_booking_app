import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class OnboardingDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingDots({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          height: AppSpacing.s,
          width: isActive ? 28 : AppSpacing.s,
          decoration: BoxDecoration(
            color: isActive
                ? context.colors.secondary
                : context.ext.textLight.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        );
      }),
    );
  }
}
