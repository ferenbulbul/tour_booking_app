import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class FavoriteCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String city;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const FavoriteCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.city,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ------------------------------------------------------
            // IMAGE
            // ------------------------------------------------------
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadius.large),
              ),
              child: Hero(
                tag: "tourImage_$id",
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 115,
                  height: 120,
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  placeholder: (_, __) => Container(
                    width: 115,
                    height: 120,
                    color: scheme.surfaceVariant.withOpacity(.3),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 115,
                    height: 120,
                    color: scheme.surfaceVariant,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.m),

            // ------------------------------------------------------
            // TEXTS
            // ------------------------------------------------------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    city,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.s),

            // ------------------------------------------------------
            // FAVORITE ICON BUTTON
            // ------------------------------------------------------
            GestureDetector(
              onTap: () {
                onFavoriteToggle();
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavorite),
                  color: isFavorite
                      ? scheme.error
                      : scheme.onSurfaceVariant.withOpacity(.6),
                  size: 26,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.m),
          ],
        ),
      ),
    );
  }
}
