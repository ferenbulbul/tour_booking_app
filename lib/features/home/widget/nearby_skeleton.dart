import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class NearbySkeleton extends StatelessWidget {
  const NearbySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.ml),
      itemBuilder: (_, __) => const _NearbyCardSkeleton(),
    );
  }
}

class _NearbyCardSkeleton extends StatelessWidget {
  const _NearbyCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Container(
        height: 180,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT: IMAGE PLACEHOLDER
            Container(
              width: 140,
              color: context.ext.shimmerBase,
            ),

            // RIGHT: CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.ml,
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE (2 lines)
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.ext.shimmerBase,
                        borderRadius:
                            BorderRadius.circular(AppRadius.xxs),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      height: 16,
                      width: 100,
                      decoration: BoxDecoration(
                        color: context.ext.shimmerBase,
                        borderRadius:
                            BorderRadius.circular(AppRadius.xxs),
                      ),
                    ),

                    const Spacer(),

                    // STAR RATING ROW
                    Row(
                      children: List.generate(
                        5,
                        (_) => Padding(
                          padding: const EdgeInsets.only(
                              right: AppSpacing.xxs),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: context.ext.shimmerBase,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xxs),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // DURATION ROW (icon + text)
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
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // LOCATION ROW (icon + text)
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
            ),
          ],
        ),
      ),
    );
  }
}
