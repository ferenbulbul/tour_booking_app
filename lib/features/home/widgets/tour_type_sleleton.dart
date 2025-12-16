import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

class CategoryCardSkeleton extends StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: shimmer.Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // ----- LEFT IMAGE SKELETON -----
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey.shade300,
                ),
              ),

              const SizedBox(width: 14),

              // ----- TEXT AREA SKELETON -----
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık skeleton
                    Container(
                      height: 18,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Açıklama Skeleton (2 satır)
                    Container(
                      height: 14,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Sağdaki icon skeleton
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
