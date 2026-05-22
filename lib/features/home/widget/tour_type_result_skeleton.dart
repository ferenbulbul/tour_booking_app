import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TourCardSkeleton extends StatelessWidget {
  const TourCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
      itemBuilder: (_, __) => _PerformanceSkeletonCard(),
    );
  }
}

class _PerformanceSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xlm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (exact 220 height)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xlm),
              ),
              child: Container(
                height: 220,
                width: double.infinity,
                color: context.colors.surface,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE placeholder
                  Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.m),

                  /// BADGES placeholder (3 badge)
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.s,
                    children: List.generate(3, (_) {
                      return Container(
                        height: 26,
                        width: 90,
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xxxxl),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppSpacing.m),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
