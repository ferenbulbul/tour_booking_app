import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class BookingsSkeleton extends StatelessWidget {
  const BookingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.l,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION TITLE SKELETON
            Row(
              children: [
                Container(
                  width: 140,
                  height: 16,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Container(
                  width: 24,
                  height: 18,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.ms),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.ml),

            // UPCOMING CARD SKELETON (large)
            const _LargeCardSkeleton(),
            const SizedBox(height: AppSpacing.ml),
            const _LargeCardSkeleton(),

            const SizedBox(height: AppSpacing.xxlm),

            // PAST SECTION TITLE
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(height: AppSpacing.ml),

            // PAST TILE SKELETONS
            const _CompactTileSkeleton(),
            const SizedBox(height: AppSpacing.ms),
            const _CompactTileSkeleton(),
            const SizedBox(height: AppSpacing.ms),
            const _CompactTileSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _LargeCardSkeleton extends StatelessWidget {
  const _LargeCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE AREA
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.ms),
                Container(
                  width: 180,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.ml),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactTileSkeleton extends StatelessWidget {
  const _CompactTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
