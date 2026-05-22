import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Normal grid card
class FavoriteCard extends StatelessWidget {
  final FeaturedTourPointDto item;

  const FavoriteCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();
    final rating = item.avgRating ?? 0.0;

    return Semantics(
      label: 'View tour details',
      child: GestureDetector(
        onTap: () {
          context.read<HomeViewModel>().onTourClicked(
            cityId: item.cityId,
            cityName: item.cityName,
          );
          context.pushNamed(
            'searchDetail',
            extra: {"id": item.id, "initialImage": item.mainImage, "heroTag": "fav_${item.id}"},
          );
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + HEART
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.ml),
                    child: Hero(
                      tag: "fav_${item.id}",
                      child: Semantics(
                        image: true,
                        label: 'Tour photo',
                        child: CachedNetworkImage(
                          cacheKey: "fav_${item.id}",
                          imageUrl: item.mainImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 500,
                          fadeInDuration: const Duration(milliseconds: 120),
                          placeholder: (_, __) => Container(
                            color: context.colors.outline.withValues(alpha: 0.3),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: context.colors.outline.withValues(alpha: 0.3),
                            child: Icon(
                              SolarIconsOutline.galleryRemove,
                              color: context.ext.textLight,
                              size: AppIconSize.l,
                              semanticLabel: 'Image not available',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.s,
                  right: AppSpacing.s,
                  child: Semantics(
                    button: true,
                    label: 'Remove from favorites',
                    child: GestureDetector(
                      onTap: () => favVm.toggleFavorite(item.id),
                      child: Container(
                        width: AppSpacing.xxxl,
                        height: AppSpacing.xxxl,
                        decoration: BoxDecoration(
                          color: context.colors.surface.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.favorite, color: context.colors.error, size: AppIconSize.ml, semanticLabel: 'Favorite'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.ms),

          // LOCATION
          Row(
            children: [
              Icon(SolarIconsOutline.mapPoint, size: AppIconSize.xsm, color: context.ext.textLight, semanticLabel: 'Location'),
              const SizedBox(width: AppSpacing.xxxs),
              Flexible(
                child: Text(
                  item.cityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // TITLE - 2 satir sabit
          SizedBox(
            height: 38,
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // 5-STAR RATING
          Row(
            children: _buildStars(context, rating),
          ),
        ],
      ),
      ),
    );
  }

  List<Widget> _buildStars(BuildContext context, double rating) {
    return List.generate(5, (i) {
      IconData icon;
      Color color;
      if (i < rating.floor()) {
        icon = Icons.star_rounded;
        color = context.colors.secondary;
      } else if (i < rating.ceil() && rating - rating.floor() >= 0.3) {
        icon = Icons.star_half_rounded;
        color = context.colors.secondary;
      } else {
        icon = Icons.star_outline_rounded;
        color = context.ext.textLight.withValues(alpha: 0.4);
      }
      return Icon(icon, size: AppIconSize.m, color: color, semanticLabel: 'Rating star');
    });
  }
}

/// Hero card - full width, only image
class FavoriteHeroCard extends StatelessWidget {
  final FeaturedTourPointDto item;

  const FavoriteHeroCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();

    return Semantics(
      button: true,
      label: 'Navigate to tour details',
      child: GestureDetector(
        onTap: () => context.pushNamed(
          'searchDetail',
          extra: {"id": item.id, "initialImage": item.mainImage},
        ),
        child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: Semantics(
              image: true,
              label: 'Tour photo',
              child: CachedNetworkImage(
                cacheKey: "fav_hero_${item.id}",
                imageUrl: item.mainImage,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                memCacheWidth: 900,
                fadeInDuration: const Duration(milliseconds: 120),
                placeholder: (_, __) => Container(
                  color: context.colors.outline.withValues(alpha: 0.3),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: context.colors.outline.withValues(alpha: 0.3),
                  child: Icon(
                    SolarIconsOutline.galleryRemove,
                    color: context.ext.textLight,
                    size: AppIconSize.xxlm,
                    semanticLabel: 'Image not available',
                  ),
                ),
              ),
            ),
          ),
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.large)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Title on image
          Positioned(
            bottom: AppSpacing.ml,
            left: AppSpacing.l,
            right: AppSpacing.l,
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          // Heart
          Positioned(
            top: AppSpacing.ms,
            right: AppSpacing.ms,
            child: Semantics(
              button: true,
              label: 'Remove from favorites',
              child: GestureDetector(
                onTap: () => favVm.toggleFavorite(item.id),
                child: Container(
                  width: AppIconSize.xxxl,
                  height: AppIconSize.xxxl,
                  decoration: BoxDecoration(
                    color: context.colors.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: context.colors.error, size: AppIconSize.l, semanticLabel: 'Favorite'),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
