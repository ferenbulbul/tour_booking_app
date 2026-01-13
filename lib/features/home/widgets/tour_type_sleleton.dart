import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero, // ❗ HomeScreen spacing'ine dokunma
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.95, // 🔥 GERÇEK KARTLA AYNI
      ),
      itemBuilder: (_, __) => const _CategoryGridSkeletonItem(),
    );
  }
}

class _CategoryGridSkeletonItem extends StatelessWidget {
  const _CategoryGridSkeletonItem();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return shimmer.Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IMAGE PLACEHOLDER
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // TITLE PLACEHOLDER (2 satır hissi)
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 14,
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
