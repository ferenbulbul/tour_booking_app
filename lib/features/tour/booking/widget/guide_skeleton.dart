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
        padding: const EdgeInsets.all(AppSpacing.ml),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
        ),
        child: Row(
          children: [
            // AVATAR (52x52, matching actual)
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: AppSpacing.m),

            // INFO COLUMN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + PRICE ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16,
                        width: 110,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      Container(
                        height: 16,
                        width: 60,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // RATING ROW (5 stars + text)
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (_) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xxs),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: context.ext.shimmerBase,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xxs),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        height: 10,
                        width: 40,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // LANGUAGES ROW (icon + text)
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        height: 12,
                        width: 90,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.s),

            // ARROW ICON
            Container(
              width: 18,
              height: 18,
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
