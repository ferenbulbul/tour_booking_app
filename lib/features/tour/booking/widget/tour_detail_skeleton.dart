import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TourDetailSkeleton extends StatelessWidget {
  const TourDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Container(
            height: 22,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 22,
            width: 180,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // RATING ROW (5 stars + text)
          Row(
            children: [
              ...List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxs),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: context.ext.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.xxs),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                height: 12,
                width: 50,
                decoration: BoxDecoration(
                  color: context.ext.shimmerBase,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // SHORT DESCRIPTION (3 lines)
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 12,
            width: 160,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // GENERAL INFO ACCORDION (non-collapsible)
          _accordionSkeleton(context, width: 130),

          const SizedBox(height: AppSpacing.xs),

          // INFO BANNER (3 info items)
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.ext.shimmerBase,
              borderRadius: BorderRadius.circular(AppRadius.ml),
            ),
          ),

          const SizedBox(height: AppSpacing.m),

          // ACCORDION 2 - Route
          _accordionSkeleton(context, width: 80),

          const SizedBox(height: AppSpacing.m),

          // ACCORDION 3 - Highlights
          _accordionSkeleton(context, width: 100),

          const SizedBox(height: AppSpacing.m),

          // ACCORDION 4 - Full Description
          _accordionSkeleton(context, width: 140),

          const SizedBox(height: AppSpacing.m),

          // ACCORDION 5 - Inclusions
          _accordionSkeleton(context, width: 90),

          const SizedBox(height: AppSpacing.xxl),

          // DEPARTURE FORM CARD
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.large),
              color: context.ext.shimmerBase,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Container(
                  height: 16,
                  width: 160,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 12,
                  width: 200,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                // Picker fields
                _pickerSkeleton(context),
                const SizedBox(height: AppSpacing.ms),
                _pickerSkeleton(context),
                const SizedBox(height: AppSpacing.ms),
                _pickerSkeleton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accordionSkeleton(BuildContext context, {required double width}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.ml),
      ),
      child: Row(
        children: [
          Container(
            height: 14,
            width: width,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const Spacer(),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickerSkeleton(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
      ),
    );
  }
}
