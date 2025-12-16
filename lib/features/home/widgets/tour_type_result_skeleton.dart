import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class TourCardSkeleton extends StatelessWidget {
  const TourCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (_, __) => const _PerformanceSkeletonCard(),
    );
  }
}

class _PerformanceSkeletonCard extends StatelessWidget {
  const _PerformanceSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (exact 220 height)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE placeholder
                  Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// BADGES placeholder (3 badge)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (_) {
                      return Container(
                        height: 26,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
