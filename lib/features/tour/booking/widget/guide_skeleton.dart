import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class GuideCardSkeleton extends StatelessWidget {
  const GuideCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto skeleton
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: AppSpacing.l),

            // Sag taraf info skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Isim skeleton
                  Container(
                    height: 16,
                    width: 140,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.ms),

                  // Fiyat skeleton
                  Container(
                    height: 14,
                    width: 90,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.ml),

                  // Chip skeletonlari
                  Row(
                    children: [
                      _chip(context),
                      const SizedBox(width: AppSpacing.s),
                      _chip(context, width: 60),
                      const SizedBox(width: AppSpacing.s),
                      _chip(context, width: 50),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.s),

            // arrow icon skeleton
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, {double width = 70}) {
    return Container(
      height: 20,
      width: width,
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    );
  }
}
