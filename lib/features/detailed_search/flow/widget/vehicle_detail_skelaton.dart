import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VehicleDetailSkeleton extends StatelessWidget {
  const VehicleDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        // 🔥 Overflow'u tamamen çözen scroll
        padding: const EdgeInsetsDirectional.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ HERO IMAGE ------------------
            Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 24),

            // ------------------ SECTION TITLE ------------------
            _titleSkeleton(),

            const SizedBox(height: 16),

            // ------------------ SPEC GRID ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(6, (_) => _specSkeleton()),
              ),
            ),

            const SizedBox(height: 30),

            // ------------------ FEATURE TITLE ------------------
            _titleSkeleton(),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(4, (_) => _featureSkeleton()),
              ),
            ),

            const SizedBox(height: 30),

            // ------------------ DRIVER SECTION ------------------
            _titleSkeleton(),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _driverSkeleton(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------- SMALL TITLE ----------------
  Widget _titleSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 22,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  // ---------------- SPEC ITEM ------------------
  Widget _specSkeleton() {
    return Container(
      width: 160,
      height: 85,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ---------------- FEATURE ITEM ------------------
  Widget _featureSkeleton() {
    return Container(
      width: 160,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ---------------- DRIVER BOX ------------------
  Widget _driverSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(18),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Languages chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              3,
              (_) => Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
