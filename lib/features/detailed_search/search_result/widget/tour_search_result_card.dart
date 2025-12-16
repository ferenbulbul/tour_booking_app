import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
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
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ------------------------------------------------------
            /// IMAGE (Same 190 height as the other card)
            /// ------------------------------------------------------
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.large),
              ),
              child: Hero(
                tag: "tourImage_${point.id}",

                child: CachedNetworkImage(
                  cacheKey: "featured_${point.id}",
                  imageUrl: point.mainImage,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  memCacheHeight: 900,

                  fadeInDuration: const Duration(milliseconds: 120),
                  placeholder: (_, __) => Container(
                    height: 190,
                    color: Colors.black.withOpacity(.08),
                  ),
                ),
              ),
            ),

            /// ------------------------------------------------------
            /// CONTENT — SAME SPACING AS OTHER CARD
            /// ------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m), // ~12px
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    point.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 18, // diğer kart ile aynı
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s),

                  /// BADGES
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      AppBadge("${point.cityName}, ${point.districtName}"),
                      AppBadge(point.tourTypeName),
                      DifficultyBadge(point.tourDifficultyName),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.s),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
