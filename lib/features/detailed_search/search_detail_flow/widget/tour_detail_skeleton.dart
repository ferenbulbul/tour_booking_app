import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/shimmer_wrapper..dart';

class TourDetailSkeleton extends StatelessWidget {
  const TourDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // header image placeholder
          Container(
            height: 330,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(22),
            ),
          ),

          // küçük margin
          const SizedBox(height: 8),

          // description box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // "Your Departure Details" title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 20,
              width: 180,
              color: Colors.grey.shade300,
            ),
          ),

          const SizedBox(height: 14),

          // 3–4 field skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _fieldSkeleton(),
                const SizedBox(height: 12),
                _fieldSkeleton(),
                const SizedBox(height: 12),
                _fieldSkeleton(),
                const SizedBox(height: 12),
                _fieldSkeleton(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // button skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _fieldSkeleton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
