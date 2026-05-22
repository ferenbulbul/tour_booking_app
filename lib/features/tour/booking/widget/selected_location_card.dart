import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class SelectedLocationCard extends StatelessWidget {
  final String description;

  const SelectedLocationCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: context.colors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.ms),
        border: Border.all(
          color: context.colors.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(SolarIconsOutline.mapPoint, color: context.colors.secondary, size: AppIconSize.l, semanticLabel: 'Location'),
          const SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
