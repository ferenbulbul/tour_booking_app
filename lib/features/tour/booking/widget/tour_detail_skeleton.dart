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
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBox(context, height: 330, radius: AppRadius.xlm),
              const SizedBox(height: AppSpacing.s),
              _buildBox(context, height: 140, radius: AppRadius.xl),
              const SizedBox(height: AppSpacing.xxl),
              _buildBox(context, height: 20, radius: AppRadius.sm, widthRatio: .5),
              const SizedBox(height: AppSpacing.ml),
              _buildBox(context, height: 56, radius: AppRadius.large),
              const SizedBox(height: AppSpacing.m),
              _buildBox(context, height: 56, radius: AppRadius.large),
              const SizedBox(height: AppSpacing.m),
              _buildBox(context, height: 56, radius: AppRadius.large),
              const SizedBox(height: AppSpacing.m),
              _buildBox(context, height: 56, radius: AppRadius.large),
              const SizedBox(height: AppSpacing.xxxxxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(
    BuildContext context, {
    required double height,
    required double radius,
    double widthRatio = 1,
  }) {
    return FractionallySizedBox(
      widthFactor: widthRatio,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.ext.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
