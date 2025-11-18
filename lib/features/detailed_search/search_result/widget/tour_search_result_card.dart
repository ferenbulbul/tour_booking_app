import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';

class TourSearchResultCard extends StatelessWidget {
  final dynamic point;

  const TourSearchResultCard({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        'searchDetail',
        extra: {"id": point.id, "initialImage": point.mainImage},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            /// --- HERO IMAGE ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Hero(
                tag: "tourImage_${point.id}",
                child: CachedNetworkImage(
                  imageUrl: point.mainImage,
                  cacheKey: "featured_${point.id}",
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
                  /// -------- TITLE --------
                  Text(
                    point.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// -------- BADGES --------
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      AppBadge("${point.cityName}, ${point.districtName}"),
                      AppBadge(point.tourTypeName),
                      DifficultyBadge(point.tourDifficultyName),
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
