import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Vehicle image carousel with brand/price row, company name, and rating.
///
/// Used in [VehicleDetailSheet] to display the top header area including
/// a swipeable photo carousel, close button, photo counter, and vehicle
/// identity information.
class VehicleInfoHeader extends StatelessWidget {
  final List<String> images;
  final int currentPage;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final String vehicleBrand;
  final String formattedPrice;
  final String? companyName;
  final double? avgRating;
  final int? ratingCount;
  final void Function(List<String> images, int index) onOpenGallery;
  final VoidCallback onClose;

  const VehicleInfoHeader({
    super.key,
    required this.images,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.vehicleBrand,
    required this.formattedPrice,
    this.companyName,
    this.avgRating,
    this.ratingCount,
    required this.onOpenGallery,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm),

        // Swipeable photo carousel with counter + close button
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.ml),
          child: Stack(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (_, i) => Semantics(
                    button: true,
                    label: 'View photo ${i + 1} in gallery',
                    child: GestureDetector(
                      onTap: () => onOpenGallery(images, i),
                      child: Semantics(
                        image: true,
                        label: 'Vehicle photo',
                        child: CachedNetworkImage(
                          imageUrl: images[i],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 200,
                            color: context.colors.outline.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Close button -- top right
              Positioned(
                right: AppSpacing.s,
                top: AppSpacing.s,
                child: Semantics(
                  button: true,
                  label: 'Close vehicle details',
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: AppIconSize.ml,
                        color: Colors.white,
                        semanticLabel: 'Close',
                      ),
                    ),
                  ),
                ),
              ),
              // Photo counter badge
              if (images.length > 1)
                Positioned(
                  left: AppSpacing.s,
                  bottom: AppSpacing.s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Text(
                      "${currentPage + 1}/${images.length}",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.ml),

        // Brand + price row
        Row(
          children: [
            Expanded(
              child: Text(
                vehicleBrand,
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formattedPrice,
              style: AppTextStyles.titleSmall.copyWith(
                color: context.colors.secondary,
              ),
            ),
          ],
        ),

        // Company name
        if (companyName != null && companyName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Row(
              children: [
                Icon(SolarIconsOutline.buildings,
                    size: AppIconSize.m,
                    color: context.colors.onSurfaceVariant,
                    semanticLabel: 'Company'),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    companyName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Rating
        if (avgRating != null && avgRating! > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              ...List.generate(5, (i) {
                final r = avgRating!;
                IconData icon;
                if (i < r.floor()) {
                  icon = Icons.star_rounded;
                } else if (i < r.ceil() && r - r.floor() >= 0.5) {
                  icon = Icons.star_half_rounded;
                } else {
                  icon = Icons.star_outline_rounded;
                }
                return Icon(icon,
                    size: AppIconSize.m,
                    color: context.ext.warning,
                    semanticLabel: 'Rating star');
              }),
              const SizedBox(width: AppSpacing.xs),
              Text(
                "${avgRating!.toStringAsFixed(1)} (${ratingCount ?? 0})",
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
