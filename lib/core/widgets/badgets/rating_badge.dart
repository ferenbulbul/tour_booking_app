import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

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
        Icon(Icons.star_rounded, size: compact ? 14 : 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          avgRating!.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          "($ratingCount)",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );

    // 🔥 compact ise SADECE içerik
    if (compact) {
      return content;
    }

    // 🔥 default = BADGE'li görünüm
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: content,
    );
  }
}
