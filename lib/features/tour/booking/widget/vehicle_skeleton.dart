import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class VehicleCardSkeleton extends StatelessWidget {
  const VehicleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE (160h, matching actual)
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.medium),
                ),
              ),
            ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BRAND + PRICE ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      Container(
                        height: 16,
                        width: 70,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // COMPANY ROW (icon + text)
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // RATING (5 stars + text)
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (_) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xxs),
                          child: Container(
                            width: 14,
                            height: 14,
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
                        width: 45,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // SPECS ROW (seat + dot + type + dot + class)
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        height: 12,
                        width: 50,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        height: 12,
                        width: 40,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        height: 12,
                        width: 50,
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
          ],
        ),
      ),
    );
  }
}
