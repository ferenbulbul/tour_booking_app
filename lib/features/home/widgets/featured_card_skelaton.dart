import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);

    return SizedBox(
      width: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                // IMAGE PLACEHOLDER
                Positioned.fill(child: Container(color: Colors.grey.shade300)),

                // GRADIENT SIMULATION (çok hafif)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),

                // CATEGORY BADGE PLACEHOLDER
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // TITLE + SUBTITLE PLACEHOLDER
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
