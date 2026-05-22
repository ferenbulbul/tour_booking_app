import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ext.surfaceLight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: const [
            _ProfileHeaderSkeleton(),
            SizedBox(height: AppSpacing.xxxl - 2),

            // HESAP AYARLARI
            _SectionTitleSkeleton(),
            SizedBox(height: AppSpacing.ms),
            _TileSkeleton(),
            _TileSkeleton(),

            SizedBox(height: AppSpacing.xxxl - 2),

            // SECURITY
            _SectionTitleSkeleton(),
            SizedBox(height: AppSpacing.ms),
            _TileSkeleton(),

            SizedBox(height: AppSpacing.xxxl - 2),

            // OTHER
            _SectionTitleSkeleton(),
            SizedBox(height: AppSpacing.ms),
            _TileSkeleton(),
            _TileSkeleton(),
          ],
        ),
      ),
    );
  }
}

//
// --------------------- HEADER SKELETON ---------------------
//

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.ext.shimmerBase,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // Name Placeholder
          Container(
            height: 18,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.small),
              color: context.ext.shimmerBase,
            ),
          ),

          const SizedBox(height: AppSpacing.ms),

          // Email Placeholder
          Container(
            height: 14,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.small),
              color: context.ext.shimmerBase,
            ),
          ),
        ],
      ),
    );
  }
}

//
// --------------------- SECTION TITLE SKELETON ---------------------
//

class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: Container(
        height: 18,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.small),
          color: context.ext.shimmerBase,
        ),
      ),
    );
  }
}

//
// --------------------- TILE SKELETON ---------------------
//

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: AppSpacing.l + 2),
      child: Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Row(
          children: [
            // Icon Placeholder
            Container(
              width: AppSpacing.xxl,
              height: AppSpacing.xxl,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: context.ext.shimmerBase,
              ),
            ),

            const SizedBox(width: AppSpacing.l),

            // Text Placeholder
            Expanded(
              child: Container(
                height: AppSpacing.l,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  color: context.ext.shimmerBase,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.l),

            // Arrow Placeholder
            Container(
              width: AppSpacing.l,
              height: AppSpacing.l,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xs),
                color: context.ext.shimmerBase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
