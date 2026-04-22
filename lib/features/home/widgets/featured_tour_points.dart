import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/featured_card_skelaton.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final targetWidth = (220 * dpr).round();

    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: "tourImage_$id",
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: targetWidth,
                      maxWidthDiskCache: targetWidth,
                      fadeInDuration: const Duration(milliseconds: 180),
                      placeholder: (_, __) => Container(
                        color: scheme.surfaceContainerHighest.withOpacity(0.2),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: scheme.surfaceContainerHighest.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),

                // GRADIENT
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.30),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                ),

                // CATEGORY BADGE
                if (avgRating != null &&
                    ratingCount != null &&
                    ratingCount! > 0)
                  Positioned(
                    top: AppSpacing.s,
                    right: AppSpacing.s,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m, // ⬅️ biraz daha geniş
                        vertical: AppSpacing.xs + 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16, // ⬅️ yıldız da büyüdü
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${avgRating!.toStringAsFixed(1)} (${ratingCount!})",
                            style: AppTextStyles.labelLarge.copyWith(
                              fontSize: 13.5, // ⬅️ net okunurluk
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // TITLE + SUBTITLE
                Positioned(
                  left: AppSpacing.m,
                  right: AppSpacing.m,
                  bottom: AppSpacing.l,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white.withOpacity(.95),
                          ),
                        ),
                      ],
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

class FeaturedPointsWidget extends StatelessWidget {
  const FeaturedPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoading);
    final featuredPoints = context.select<HomeViewModel, List<FeaturedTourPointDto>>(
      (vm) => vm.featuredPoints,
    );

    if (isLoading) {
      return const FeaturedPointsSkeleton();
    }

    if (featuredPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        key: const PageStorageKey("featured_list"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        itemCount: featuredPoints.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
        itemBuilder: (context, index) {
          final p = featuredPoints[index];

          return FeaturedCard(
            id: p.id,
            imageUrl: p.mainImage,
            title: p.title,
            subtitle: p.cityName,
            avgRating: p.avgRating,
            ratingCount: p.ratingCount,
            onTap: () => context.pushNamed(
              'searchDetail',
              extra: {"id": p.id, "initialImage": p.mainImage},
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => const FeaturedCardSkeleton(),
      ),
    );
  }
}
