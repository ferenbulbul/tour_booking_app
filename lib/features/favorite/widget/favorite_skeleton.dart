import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FavoriteSkeleton extends StatelessWidget {
  const FavoriteSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final heroHeight = media.size.height * 0.35;

    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // HERO IMAGE PLACEHOLDER
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Full image area
                Container(
                  height: heroHeight,
                  width: double.infinity,
                  color: context.ext.shimmerBase,
                ),

                // Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                ),

                // Title placeholder (bottom-left)
                Positioned(
                  bottom: AppSpacing.l,
                  left: AppSpacing.l,
                  child: Container(
                    height: 24,
                    width: 160,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.xxs),
                    ),
                  ),
                ),

                // Heart icon placeholder (top-right)
                Positioned(
                  top: media.padding.top + AppSpacing.ms,
                  right: AppSpacing.ml,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // GRID CARDS
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.l,
              AppSpacing.screenPadding,
              AppSpacing.l,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.l,
                crossAxisSpacing: AppSpacing.ml,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, _) => _CardSkeleton(
                  shimmerBase: context.ext.shimmerBase,
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  final Color shimmerBase;
  const _CardSkeleton({required this.shimmerBase});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE with heart button
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: shimmerBase,
                    borderRadius: BorderRadius.circular(AppRadius.ml),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.s,
                right: AppSpacing.s,
                child: Container(
                  width: AppSpacing.xxxl,
                  height: AppSpacing.xxxl,
                  decoration: BoxDecoration(
                    color: shimmerBase,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.ms),

        // LOCATION ROW
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(width: AppSpacing.xxxs),
            Container(
              height: 10,
              width: 60,
              decoration: BoxDecoration(
                color: shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xs),

        // TITLE (2 lines)
        Container(
          height: 14,
          width: double.infinity,
          decoration: BoxDecoration(
            color: shimmerBase,
            borderRadius: BorderRadius.circular(AppRadius.xxs),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: shimmerBase,
            borderRadius: BorderRadius.circular(AppRadius.xxs),
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        // 5-STAR RATING ROW
        Row(
          children: List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xxs),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: shimmerBase,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
