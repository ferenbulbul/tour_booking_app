import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.95, // Matches the actual card ratio
      ),
      itemBuilder: (_, __) => const _CategoryGridSkeletonItem(),
    );
  }
}

class _CategoryGridSkeletonItem extends StatelessWidget {
  const _CategoryGridSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return shimmer.Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IMAGE PLACEHOLDER
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // TITLE PLACEHOLDER (2 line effect)
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 14,
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }
}
