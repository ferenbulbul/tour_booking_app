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
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: context.ext.shimmerBase,
        highlightColor: context.ext.shimmerHighlight,
        child: Container(
          height: 240,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
        ),
      ),
    );
  }
}
