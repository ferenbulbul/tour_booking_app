import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
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
    if (h > 0 && m > 0) return tr('duration_short', namedArgs: {'hours': h.toString(), 'minutes': m.toString()});
    if (h > 0) return tr('duration_short_hours_only', namedArgs: {'hours': h.toString()});
    return tr('duration_short_minutes_only', namedArgs: {'minutes': m.toString()});
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

    return Semantics(
      button: true,
      label: 'Navigate to tour details',
      child: GestureDetector(
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
        margin: const EdgeInsets.only(bottom: AppSpacing.ml),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
          border: Border.all(color: context.colors.outline, width: 1),
        ),
        child: SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT: IMAGE
              Stack(
                children: [
                  Semantics(
                    image: true,
                    label: title,
                    child: SizedBox(
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
                            color: context.colors.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // DISTANCE BADGE
                  if (distance != null)
                    Positioned(
                      top: AppSpacing.s,
                      right: AppSpacing.s,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          "${distance!.toStringAsFixed(1)} km",
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // FAVORITE
                  Positioned(
                    top: AppSpacing.s,
                    left: AppSpacing.s,
                    child: Semantics(
                      button: true,
                      toggled: isFav,
                      label: 'Toggle favorite',
                      child: GestureDetector(
                        onTap: () => favVm.toggleFavorite(id),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: context.colors.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? context.colors.error : context.ext.textLight,
                            size: AppIconSize.m,
                            semanticLabel: isFav ? 'Favorite' : 'Not favorite',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // RIGHT: CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.ml, AppSpacing.l, AppSpacing.m, AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE - fixed 2 lines
                      SizedBox(
                        height: 42,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colors.onSurface,
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
                              return Icon(Icons.star_rounded, size: AppIconSize.l, color: context.colors.secondary, semanticLabel: 'Rating star');
                            } else if (i < rating.ceil() && rating % 1 >= 0.3) {
                              return Icon(Icons.star_half_rounded, size: AppIconSize.l, color: context.colors.secondary, semanticLabel: 'Rating star half');
                            } else {
                              return Icon(Icons.star_outline_rounded, size: AppIconSize.l, color: context.ext.textLight.withValues(alpha: 0.5), semanticLabel: 'Rating star empty');
                            }
                          }),
                        ],
                      ),

                      const Spacer(),

                      // DURATION
                      if (hasDuration)
                        Row(
                          children: [
                            Icon(SolarIconsOutline.clockCircle, size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Duration'),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _formatDuration(durationHours, durationMinutes),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: AppSpacing.sm),

                      // LOCATION
                      if (_locationText.isNotEmpty)
                        Row(
                          children: [
                            Icon(SolarIconsOutline.mapPoint, size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Location'),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                _locationText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: context.colors.onSurfaceVariant,
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
      ),
    );
  }
}
