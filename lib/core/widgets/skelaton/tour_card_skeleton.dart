import 'package:flutter/material.dart';

class TourCardSkeleton extends StatelessWidget {
  const TourCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }
}
