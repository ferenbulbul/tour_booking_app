import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class ThumbStrip extends StatelessWidget {
  final List<String> images;
  final void Function(int index) onTap;

  const ThumbStrip({super.key, required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final img = images[index];

          return GestureDetector(
            onTap: () => onTap(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.small),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: CachedNetworkImage(
                  imageUrl: img,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.grey.shade300),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
