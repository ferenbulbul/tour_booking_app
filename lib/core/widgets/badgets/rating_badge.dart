import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class RatingBadge extends StatelessWidget {
  final double? avgRating;
  final int? ratingCount;
  final bool compact;

  const RatingBadge({
    super.key,
    this.avgRating,
    this.ratingCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (avgRating == null || ratingCount == null || ratingCount == 0) {
      return const SizedBox.shrink();
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: compact ? AppIconSize.s : AppIconSize.ml, color: context.ext.star, semanticLabel: 'Rating star'),
        const SizedBox(width: AppSpacing.xs),
        Text(
          avgRating!.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          "($ratingCount)",
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );

    // If compact, return content only
    if (compact) {
      return content;
    }

    // Default = badge view
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
      ),
      child: content,
    );
  }
}
