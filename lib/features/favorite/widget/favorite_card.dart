import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';

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

    return GestureDetector(
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
                    borderRadius: BorderRadius.circular(14),
                    child: Hero(
                      tag: "fav_${item.id}",
                      child: CachedNetworkImage(
                        cacheKey: "fav_${item.id}",
                        imageUrl: item.mainImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        memCacheWidth: 500,
                        fadeInDuration: const Duration(milliseconds: 120),
                        placeholder: (_, __) => Container(
                          color: AppColors.border.withValues(alpha: 0.3),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.border.withValues(alpha: 0.3),
                          child: const Icon(
                            SolarIconsOutline.galleryRemove,
                            color: AppColors.textLight,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => favVm.toggleFavorite(item.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LOCATION
          Row(
            children: [
              const Icon(SolarIconsOutline.mapPoint, size: 13, color: AppColors.textLight),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  item.cityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // TITLE - 2 satir sabit
          SizedBox(
            height: 38,
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // 5-STAR RATING
          Row(
            children: _buildStars(rating),
          ),
        ],
      ),
    );
  }

  static List<Widget> _buildStars(double rating) {
    return List.generate(5, (i) {
      IconData icon;
      Color color;
      if (i < rating.floor()) {
        icon = Icons.star_rounded;
        color = AppColors.accent;
      } else if (i < rating.ceil() && rating - rating.floor() >= 0.3) {
        icon = Icons.star_half_rounded;
        color = AppColors.accent;
      } else {
        icon = Icons.star_outline_rounded;
        color = AppColors.textLight.withValues(alpha: 0.4);
      }
      return Icon(icon, size: 16, color: color);
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

    return GestureDetector(
      onTap: () => context.pushNamed(
        'searchDetail',
        extra: {"id": item.id, "initialImage": item.mainImage},
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              cacheKey: "fav_hero_${item.id}",
              imageUrl: item.mainImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              memCacheWidth: 900,
              fadeInDuration: const Duration(milliseconds: 120),
              placeholder: (_, __) => Container(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.border.withValues(alpha: 0.3),
                child: const Icon(
                  SolarIconsOutline.galleryRemove,
                  color: AppColors.textLight,
                  size: 32,
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
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
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
            bottom: 14,
            left: 16,
            right: 16,
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
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => favVm.toggleFavorite(item.id),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
