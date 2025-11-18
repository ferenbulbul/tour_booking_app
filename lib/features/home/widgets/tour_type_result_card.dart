import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';

class TourTypeResultCard extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final String city;
  final String? district;
  final String? difficulty;
  final VoidCallback onTap;

  const TourTypeResultCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.city,
    required this.district,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final districtText = district != null && district!.isNotEmpty
        ? "$city, $district"
        : city;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HERO IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Hero(
                tag: "tourImage_$id",
                child: CachedNetworkImage(
                  imageUrl: image,
                  cacheKey: "featured_$id",
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// BADGES
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      AppBadge(districtText),
                      if (difficulty != null && difficulty!.isNotEmpty)
                        DifficultyBadge(difficulty!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
