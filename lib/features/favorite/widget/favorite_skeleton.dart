import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FavoriteSkeleton extends StatelessWidget {
  const FavoriteSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.ml,
        mainAxisSpacing: AppSpacing.ml,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const _CardSkeleton(),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.ml),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // LOCATION
          Container(
            height: 10,
            width: 60,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // TITLE
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // RATING
          Container(
            height: 10,
            width: 50,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
        ],
      ),
    );
  }
}
