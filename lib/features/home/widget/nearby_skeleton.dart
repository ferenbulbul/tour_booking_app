import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class NearbySkeleton extends StatelessWidget {
  const NearbySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.l),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.ml,
        mainAxisSpacing: AppSpacing.ml,
        childAspectRatio: 0.77,
      ),
      itemBuilder: (context, i) {
        return Shimmer.fromColors(
          baseColor: context.ext.shimmerBase,
          highlightColor: context.ext.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lm),
            ),
          ),
        );
      },
    );
  }
}
