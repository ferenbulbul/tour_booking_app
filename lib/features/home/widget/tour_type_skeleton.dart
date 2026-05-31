import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (_, __) => const _CategoryCardSkeletonItem(),
      ),
    );
  }
}

class _CategoryCardSkeletonItem extends StatelessWidget {
  const _CategoryCardSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE PLACEHOLDER (200h matching actual)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
            ),

            const SizedBox(height: AppSpacing.s),

            // TITLE PLACEHOLDER (2 lines)
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
              width: 120,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),

            const SizedBox(height: AppSpacing.xxs),

            // DESCRIPTION PLACEHOLDER (2 lines)
            Container(
              height: 12,
              width: 180,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxs),
            Container(
              height: 12,
              width: 140,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
