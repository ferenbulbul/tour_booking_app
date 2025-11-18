import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class DescriptionSection extends StatelessWidget {
  final dynamic detail;

  const DescriptionSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        detail.description,
        style: AppTextStyles.bodyMedium.copyWith(
          height: 1.45,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
