import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DescriptionSection extends StatelessWidget {
  final dynamic detail;

  const DescriptionSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppElevation.shadowMd,
      ),
      child: Text(
        detail.description,
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.45,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
