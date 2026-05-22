import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);

    return SizedBox(
      width: 200,
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Container(
          decoration: BoxDecoration(
            color: context.ext.shimmerBase,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                // IMAGE PLACEHOLDER
                Positioned.fill(child: Container(color: context.ext.shimmerBase)),

                // GRADIENT SIMULATION
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),

                // CATEGORY BADGE PLACEHOLDER
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                  ),
                ),

                // TITLE + SUBTITLE PLACEHOLDER
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
