import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class NearbyCard extends StatelessWidget {
  final String image;
  final String title;
  final String city;
  final String type;
  final double distance;
  final double? avgRating;
  final double? ratingCount;
  final int? durationHours;
  final int? durationMinutes;

  const NearbyCard({
    super.key,
    required this.image,
    required this.title,
    required this.city,
    required this.type,
    required this.distance,
    this.avgRating,
    this.ratingCount,
    this.durationHours,
    this.durationMinutes,
  });

  static String _formatDuration(int? hours, int? minutes) {
    final h = hours ?? 0;
    final m = minutes ?? 0;
    if (h > 0 && m > 0) return "${h}s ${m}dk";
    if (h > 0) return "${h} saat";
    return "${m} dk";
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Semantics(
      label: '$title, $city',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lm),
        child: Container(
        color: scheme.surface,
        child: Stack(
          children: [
            // ---------------- IMAGE ----------------
            Semantics(
              image: true,
              excludeSemantics: true,
              label: title,
              child: CachedNetworkImage(
                imageUrl: image,
                memCacheHeight: 350, // Performance optimization
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 150),
                placeholder: (_, __) =>
                    Container(color: scheme.surfaceContainerHighest.withValues(alpha: 0.30)),
              ),
            ),

            // ---------------- DISTANCE BADGE ----------------
            Positioned(
              right: AppSpacing.ms,
              top: AppSpacing.ms,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.ms),
                ),
                child: Text(
                  "${distance.toStringAsFixed(1)} km",
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ---------------- GRADIENT ----------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 110,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.38),
                      Colors.black.withValues(alpha: 0.87),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // ---------------- TEXT ----------------
            Positioned(
              left: AppSpacing.ml,
              right: AppSpacing.ml,
              bottom: AppSpacing.ml,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STAR RATING + DURATION
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final rating = (avgRating != null && ratingCount != null && ratingCount! > 0) ? avgRating! : 0.0;
                        if (i < rating.floor()) {
                          return Icon(Icons.star_rounded, size: AppIconSize.s, color: context.ext.star, semanticLabel: 'Rating star');
                        } else if (i < rating.ceil() && rating % 1 >= 0.3) {
                          return Icon(Icons.star_half_rounded, size: AppIconSize.s, color: context.ext.star, semanticLabel: 'Rating star half');
                        } else {
                          return Icon(Icons.star_outline_rounded, size: AppIconSize.s, color: Colors.white.withValues(alpha: 0.5), semanticLabel: 'Rating star empty');
                        }
                      }),
                      if (durationHours != null || durationMinutes != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.schedule_rounded, size: AppIconSize.xs, color: Colors.white.withValues(alpha: 0.8), semanticLabel: 'Duration'),
                        const SizedBox(width: AppSpacing.xxxs),
                        Text(
                          _formatDuration(durationHours, durationMinutes),
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // CITY + TYPE
                  Text(
                    "$city \u2022 $type",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
