import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _ProfileHeaderSkeleton(),
            SizedBox(height: 30),

            // HESAP AYARLARI
            _SectionTitleSkeleton(),
            SizedBox(height: 10),
            _TileSkeleton(),
            _TileSkeleton(),

            SizedBox(height: 30),

            // GÜVENLİK
            _SectionTitleSkeleton(),
            SizedBox(height: 10),
            _TileSkeleton(),

            SizedBox(height: 30),

            // DİĞER
            _SectionTitleSkeleton(),
            SizedBox(height: 10),
            _TileSkeleton(),
            _TileSkeleton(),
          ],
        ),
      ),
    );
  }
}

//
// --------------------- HEADER SKELETON ---------------------
//

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Name Placeholder
          Container(
            height: 18,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
          ),

          const SizedBox(height: 10),

          // Email Placeholder
          Container(
            height: 14,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}

//
// --------------------- SECTION TITLE SKELETON ---------------------
//

class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 18,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}

//
// --------------------- TILE SKELETON ---------------------
//

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 18),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Icon Placeholder
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.shade300,
              ),
            ),

            const SizedBox(width: 16),

            // Text Placeholder
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Arrow Placeholder
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
