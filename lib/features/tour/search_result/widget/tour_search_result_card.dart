import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';

class TourSearchResultCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String? cityId;
  final String? cityName;
  final String? districtName;
  final double? avgRating;
  final int? ratingCount;
  final int? durationHours;
  final int? durationMinutes;
  final String? heroTag;
  final double? distance;

  const TourSearchResultCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    this.cityId,
    this.cityName,
    this.districtName,
    this.avgRating,
    this.ratingCount,
    this.durationHours,
    this.durationMinutes,
    this.heroTag,
    this.distance,
  });

  static String _formatDuration(int? hours, int? minutes) {
    final h = hours ?? 0;
    final m = minutes ?? 0;
    if (h > 0 && m > 0) return "$h saat $m dk";
    if (h > 0) return "$h saat";
    return "$m dk";
  }

  String get _locationText {
    if (cityName != null && districtName != null) {
      return "$cityName, $districtName";
    }
    return cityName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();
    final isFav = favVm.isFavorite(id);
    final hasRating = avgRating != null &&
        ratingCount != null &&
        ratingCount! > 0;
    final hasDuration =
        durationHours != null || durationMinutes != null;

    return GestureDetector(
      onTap: () {
        if (cityId != null && cityName != null) {
          context.read<HomeViewModel>().onTourClicked(
            cityId: cityId!,
            cityName: cityName!,
          );
        }
        context.pushNamed(
          'searchDetail',
          extra: {"id": id, "initialImage": imageUrl, if (heroTag != null) "heroTag": heroTag},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 140,
                    child: Hero(
                      tag: heroTag ?? "tourImage_$id",
                      child: CachedNetworkImage(
                        cacheKey: "featured_$id",
                        imageUrl: imageUrl,
                        width: 140,
                        height: 180,
                        fit: BoxFit.cover,
                        memCacheHeight: 540,
                        fadeInDuration: const Duration(milliseconds: 120),
                        placeholder: (_, __) => Container(
                          width: 140,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ),
                  // DISTANCE BADGE
                  if (distance != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${distance!.toStringAsFixed(1)} km",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // FAVORITE
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () => favVm.toggleFavorite(id),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : AppColors.textLight,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // RIGHT: CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE - 2 satır sabit
                      SizedBox(
                        height: 42,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // STAR RATING
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            final rating = hasRating ? avgRating! : 0.0;
                            if (i < rating.floor()) {
                              return const Icon(Icons.star_rounded, size: 20, color: AppColors.accent);
                            } else if (i < rating.ceil() && rating % 1 >= 0.3) {
                              return const Icon(Icons.star_half_rounded, size: 20, color: AppColors.accent);
                            } else {
                              return Icon(Icons.star_outline_rounded, size: 20, color: AppColors.textLight.withValues(alpha: 0.5));
                            }
                          }),
                        ],
                      ),

                      const Spacer(),

                      // DURATION
                      if (hasDuration)
                        Row(
                          children: [
                            Icon(SolarIconsOutline.clockCircle, size: 14, color: AppColors.textLight),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(durationHours, durationMinutes),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 6),

                      // LOCATION
                      if (_locationText.isNotEmpty)
                        Row(
                          children: [
                            Icon(SolarIconsOutline.mapPoint, size: 14, color: AppColors.textLight),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _locationText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
