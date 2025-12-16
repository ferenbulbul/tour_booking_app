import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.l,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 74,
                color: AppColors.textSecondary.withOpacity(.22),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  letterSpacing: -.3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
