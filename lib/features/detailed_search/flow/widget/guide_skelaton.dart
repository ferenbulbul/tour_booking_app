import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GuideCardSkeleton extends StatelessWidget {
  const GuideCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto skeleton
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 16),

            // Sağ taraf info skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İsim skeleton
                  Container(
                    height: 16,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Fiyat skeleton
                  Container(
                    height: 14,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Chip skeletonları
                  Row(
                    children: [
                      _chip(),
                      const SizedBox(width: 8),
                      _chip(width: 60),
                      const SizedBox(width: 8),
                      _chip(width: 50),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // arrow icon skeleton
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({double width = 70}) {
    return Container(
      height: 20,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
