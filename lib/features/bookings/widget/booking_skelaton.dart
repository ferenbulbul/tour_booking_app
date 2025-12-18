import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingsSkeleton extends StatelessWidget {
  const BookingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // 3–4 tane kart hissi versin
        itemBuilder: (_, __) {
          return Container(
            margin: const EdgeInsetsDirectional.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                // Üst kısım skeleton
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Row(
                    children: [
                      // ikon kutusu
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Alt bilgi skeleton
              ],
            ),
          );
        },
      ),
    );
  }
}
