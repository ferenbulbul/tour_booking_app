import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: shimmer.Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üstte image alanı
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Başlık skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
