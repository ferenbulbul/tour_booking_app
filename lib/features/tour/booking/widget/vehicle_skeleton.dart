import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class VehicleCardSkeleton extends StatelessWidget {
  const VehicleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xlm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- IMAGE SKELETON ---
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xlm),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.ml),

            // --- TITLE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Container(
                height: 18,
                width: 140,
                decoration: BoxDecoration(
                  color: context.ext.shimmerBase,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.ml),

            // --- FEATURE CHIPS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Row(
                children: [
                  _chipSkeleton(context, width: 80),
                  const SizedBox(width: AppSpacing.ms),
                  _chipSkeleton(context, width: 70),
                  const SizedBox(width: AppSpacing.ms),
                  _chipSkeleton(context, width: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipSkeleton(BuildContext context, {required double width}) {
    return Container(
      height: 26,
      width: width,
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.ms),
      ),
    );
  }
}
