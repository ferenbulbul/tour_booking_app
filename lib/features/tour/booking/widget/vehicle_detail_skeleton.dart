import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class VehicleDetailSkeleton extends StatelessWidget {
  const VehicleDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ HERO IMAGE ------------------
            Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: double.infinity,
              color: context.ext.shimmerBase,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ------------------ SECTION TITLE ------------------
            _titleSkeleton(context),

            const SizedBox(height: AppSpacing.l),

            // ------------------ SPEC GRID ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Wrap(
                spacing: AppSpacing.m,
                runSpacing: AppSpacing.m,
                children: List.generate(6, (_) => _specSkeleton(context)),
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // ------------------ FEATURE TITLE ------------------
            _titleSkeleton(context),
            const SizedBox(height: AppSpacing.l),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Wrap(
                spacing: AppSpacing.m,
                runSpacing: AppSpacing.m,
                children: List.generate(4, (_) => _featureSkeleton(context)),
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // ------------------ DRIVER SECTION ------------------
            _titleSkeleton(context),
            const SizedBox(height: AppSpacing.l),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _driverSkeleton(context),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // ---------------- SMALL TITLE ----------------
  Widget _titleSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        height: 22,
        width: 160,
        decoration: BoxDecoration(
          color: context.ext.shimmerBase,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  // ---------------- SPEC ITEM ------------------
  Widget _specSkeleton(BuildContext context) {
    return Container(
      width: 160,
      height: 85,
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.ml),
      ),
    );
  }

  // ---------------- FEATURE ITEM ------------------
  Widget _featureSkeleton(BuildContext context) {
    return Container(
      width: 160,
      height: 40,
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    );
  }

  // ---------------- DRIVER BOX ------------------
  Widget _driverSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.ext.shimmerBase,
        borderRadius: BorderRadius.circular(AppRadius.lm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.l),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 120,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Languages chips
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: List.generate(
              3,
              (_) => Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.ms),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
