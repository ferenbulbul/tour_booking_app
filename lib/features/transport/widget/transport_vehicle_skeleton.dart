import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportVehicleSkeleton extends StatelessWidget {
  const TransportVehicleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.l),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.ml),
      itemBuilder: (_, __) => const _TransportVehicleCardSkeleton(),
    );
  }
}

class _TransportVehicleCardSkeleton extends StatelessWidget {
  const _TransportVehicleCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AREA (160h) with class badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.ext.shimmerBase,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.large),
                    ),
                  ),
                ),
                // Class badge placeholder
                Positioned(
                  left: AppSpacing.ms,
                  top: AppSpacing.ms,
                  child: Container(
                    height: 22,
                    width: 60,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                  ),
                ),
              ],
            ),

            // CONTENT AREA
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
                        width: 130,
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

                  const SizedBox(height: AppSpacing.s),

                  // AGENCY ROW (icon + text)
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

                  const SizedBox(height: AppSpacing.s),

                  // RATING ROW (stars + text)
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

                  const SizedBox(height: AppSpacing.ms),

                  // SPECS ROW (seats + dot + price/km)
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          borderRadius:
                              BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.ext.shimmerBase,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Container(
                        height: 12,
                        width: 70,
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
