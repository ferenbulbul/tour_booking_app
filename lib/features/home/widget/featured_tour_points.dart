import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:tour_booking/features/home/widget/featured_card_skeleton.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';

class FeaturedCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? category;
  final VoidCallback onTap;
  final double? avgRating;
  final int? ratingCount;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final String? heroTag;
  final int? durationHours;
  final int? durationMinutes;
  final double? cardWidth;
  final double? imageHeight;

  const FeaturedCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.category,
    this.avgRating,
    this.ratingCount,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.heroTag,
    this.durationHours,
    this.durationMinutes,
    this.cardWidth,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final double resolvedWidth = cardWidth ?? 220;
    final double resolvedImageH = imageHeight ?? 200;
    final targetWidth = (resolvedWidth * dpr).round();

    final hasRating = avgRating != null &&
        ratingCount != null &&
        ratingCount! > 0;

    return SizedBox(
      width: resolvedWidth,
      child: Semantics(
        button: true,
        label: 'View tour $title',
        child: GestureDetector(
          onTap: onTap,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE + FAVORITE
            Stack(
              children: [
                Semantics(
                  image: true,
                  label: title,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    child: SizedBox(
                      height: resolvedImageH,
                      width: double.infinity,
                      child: Hero(
                        tag: heroTag ?? "tourImage_$id",
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          memCacheWidth: targetWidth,
                          maxWidthDiskCache: targetWidth,
                          fadeInDuration: const Duration(milliseconds: 180),
                          placeholder: (_, __) => Container(
                            color: context.colors.surfaceContainerHighest,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: context.colors.surfaceContainerHighest,
                            child: Icon(SolarIconsOutline.gallery, color: context.ext.textLight, semanticLabel: 'Image placeholder'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // FAVORITE BUTTON
                if (onFavoriteToggle != null)
                  Positioned(
                    top: AppSpacing.s,
                    right: AppSpacing.s,
                    child: Semantics(
                      button: true,
                      toggled: isFavorite,
                      label: 'Toggle favorite',
                      child: GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: context.colors.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(isFavorite),
                              color: isFavorite ? context.ext.favorite : context.ext.textLight,
                              size: AppIconSize.l,
                              semanticLabel: isFavorite ? 'Favorite' : 'Not favorite',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.s),

            // CONTENT AREA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RATING + DURATION ROW (above title)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, size: AppIconSize.lm, color: context.colors.secondary, semanticLabel: 'Rating star'),
                      const SizedBox(width: AppSpacing.xxxs),
                      Text(
                        hasRating ? avgRating!.toStringAsFixed(1) : "0",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.onSurface,
                        ),
                      ),
                      if (durationHours != null || durationMinutes != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            "\u00B7",
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.ext.textLight,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        if (durationHours != null || durationMinutes != null) ...[
                          Icon(SolarIconsOutline.clockCircle, size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Duration'),
                          const SizedBox(width: AppSpacing.xxxs),
                          Text(
                            _formatDuration(durationHours, durationMinutes),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // TITLE - always reserves 2-line height for alignment
                SizedBox(
                  height: 42,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: context.colors.onSurface,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxs),

                // SUBTITLE (city)
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  static String _formatDuration(int? hours, int? minutes) {
    final h = hours ?? 0;
    final m = minutes ?? 0;
    if (h > 0 && m > 0) return "${h}h ${m}m";
    if (h > 0) return "${h}h";
    return "${m}m";
  }
}

class FeaturedPointsWidget extends StatelessWidget {
  const FeaturedPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoadingFeatured);
    final featuredPoints = context.select<HomeViewModel, List<FeaturedTourPointDto>>(
      (vm) => vm.featuredPoints,
    );
    final favVm = context.watch<FavoriteViewModel>();

    if (isLoading) {
      return const FeaturedPointsSkeleton();
    }

    if (featuredPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 320,
      child: ListView.separated(
        key: const PageStorageKey("featured_list"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: featuredPoints.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final p = featuredPoints[index];

          return FeaturedCard(
            id: p.id,
            imageUrl: p.mainImage,
            title: p.title,
            subtitle: p.cityName,
            category: p.tourTypeName,
            avgRating: p.avgRating,
            ratingCount: p.ratingCount,
            durationHours: p.durationHours,
            durationMinutes: p.durationMinutes,
            heroTag: "featured_${p.id}",
            isFavorite: favVm.isFavorite(p.id),
            onFavoriteToggle: () => favVm.toggleFavorite(p.id),
            onTap: () {
              context.read<HomeViewModel>().onTourClicked(
                cityId: p.cityId,
                cityName: p.cityName,
              );
              context.pushNamed(
                'searchDetail',
                extra: {"id": p.id, "initialImage": p.mainImage, "heroTag": "featured_${p.id}"},
              );
            },
          );
        },
      ),
    );
  }
}

class FeaturedPointsSkeleton extends StatelessWidget {
  const FeaturedPointsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
        itemBuilder: (_, __) => const FeaturedCardSkeleton(),
      ),
    );
  }
}
