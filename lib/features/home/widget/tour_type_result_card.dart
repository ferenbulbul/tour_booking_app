import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';
import 'package:tour_booking/core/widgets/badgets/rating_badge.dart';

class TourTypeResultCard extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final String city;
  final String? district;
  final String? difficulty;
  final double? avgRating;
  final int? ratingCount;
  final VoidCallback? onTap;

  const TourTypeResultCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.city,
    required this.district,
    required this.difficulty,
    required this.onTap,
    this.ratingCount,
    this.avgRating,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    // District formatting
    final districtText = (district != null && district!.isNotEmpty)
        ? "$city, $district"
        : city;

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: onTap,
      child: RepaintBoundary(
        // Scroll jank fix via RepaintBoundary
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),

            // Optimized shadow (16 to 8, significant difference)
            boxShadow: AppElevation.shadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ------------------------------------------------------
              /// IMAGE (HERO + CachedNetworkImage optimized)
              /// ------------------------------------------------------
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.large),
                ),
                child: Hero(
                  // Hero tag fix — prevents hero tag conflicts
                  tag: "tourImage_${id}",
                  child: Semantics(
                    image: true,
                    label: title,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      // GPU load optimization — reduces image resolution
                      memCacheHeight: 900,

                      fadeInDuration: const Duration(milliseconds: 120),

                      placeholder: (_, __) => Container(
                        height: 190,
                        width: double.infinity,
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
                      ),

                      errorWidget: (_, __, ___) => Container(
                        height: 190,
                        color: context.ext.shimmerBase.withValues(alpha: 0.3),
                        child: const Icon(SolarIconsOutline.galleryRemove, size: AppSpacing.xxxxl, semanticLabel: 'Image not available'),
                      ),
                    ),
                  ),
                ),
              ),

              /// ------------------------------------------------------
              /// TEXT + BADGES
              /// ------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.s),

                    /// BADGES
                    Wrap(
                      spacing: AppSpacing.s,
                      runSpacing: AppSpacing.sm,
                      children: [
                        RatingBadge(
                          avgRating: avgRating,
                          ratingCount: ratingCount,
                        ),
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
      ),
      ),
    );
  }
}
