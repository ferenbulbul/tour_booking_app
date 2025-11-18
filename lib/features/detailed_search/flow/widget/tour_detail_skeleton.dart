import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class TourDetailSkeleton extends StatelessWidget {
  const TourDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 👈 EKLEDİK
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBox(height: 330, radius: 22),
            const SizedBox(height: 8),
            _buildBox(height: 140, radius: 20),
            const SizedBox(height: 24),
            _buildBox(height: 20, radius: 6, widthRatio: .5),
            const SizedBox(height: 14),
            _buildBox(height: 56, radius: 16),
            const SizedBox(height: 12),
            _buildBox(height: 56, radius: 16),
            const SizedBox(height: 12),
            _buildBox(height: 56, radius: 16),
            const SizedBox(height: 12),
            _buildBox(height: 56, radius: 16),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildBox({
    required double height,
    required double radius,
    double widthRatio = 1,
  }) {
    return FractionallySizedBox(
      widthFactor: widthRatio,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
