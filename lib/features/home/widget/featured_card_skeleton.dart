import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE PLACEHOLDER — expands to fill remaining space
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s),

          // RATING + DURATION ROW
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxxs),
                Container(
                  width: 24,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxxs),
                Container(
                  width: 32,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
              ],
            ),
          ),

          // TITLE PLACEHOLDER
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 16,
            width: 140,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // SUBTITLE PLACEHOLDER
          Container(
            height: 12,
            width: 80,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
        ],
      ),
    );
  }
}
