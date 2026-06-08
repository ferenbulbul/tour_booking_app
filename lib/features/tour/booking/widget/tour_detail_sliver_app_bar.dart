import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_bar_styles.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_header_hero.dart';

/// Extracted SliverAppBar for the tour detail screen.
class TourDetailSliverAppBar extends StatelessWidget {
  final String tourPointId;
  final dynamic detail;
  final TourDetailViewModel detailVm;
  final FavoriteViewModel favVm;
  final List<String> galleryImages;
  final String? heroTag;
  final double expandedHeight;
  final double topPadding;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onGalleryTap;

  const TourDetailSliverAppBar({
    super.key,
    required this.tourPointId,
    required this.detail,
    required this.detailVm,
    required this.favVm,
    required this.galleryImages,
    this.heroTag,
    required this.expandedHeight,
    required this.topPadding,
    required this.onBack,
    required this.onShare,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: expandedHeight,
      backgroundColor: context.colors.surface,
      title: null,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final currentHeight = constraints.biggest.height;
          final minHeight = kToolbarHeight + topPadding;
          final maxHeight = expandedHeight;

          double t = 1.0;
          if (maxHeight > minHeight) {
            t = ((currentHeight - minHeight) / (maxHeight - minHeight))
                .clamp(0.0, 1.0);
          }

          final collapseT = 1 - t;

          final double appBarBgOpacity =
              lerpDouble(0.0, 1.0, collapseT.clamp(0.0, 1.0)) ?? 0.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Hero image
              Semantics(
                button: true,
                label: 'Open image gallery',
                child: GestureDetector(
                  onTap: onGalleryTap,
                  child: TourDetailHeaderHero(
                    tourPointId: tourPointId,
                    images: galleryImages,
                    heroTag: heroTag,
                  ),
                ),
              ),

              // Top band background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topPadding + kToolbarHeight,
                child: IgnorePointer(
                  child: Container(
                    color: context.colors.surfaceContainerHighest.withValues(
                      alpha: appBarBgOpacity,
                    ),
                  ),
                ),
              ),

              // Icon bar + collapsed title
              Positioned(
                top: topPadding,
                left: 0,
                right: 0,
                height: kToolbarHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.ms),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SimpleIconButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: onBack,
                        fillColor: context.ext.surfaceLight,
                        iconColor: context.colors.onSurface,
                        tooltip: 'Back',
                      ),

                      // Collapsed title (fade in)
                      if (detail != null && collapseT >= 0.75)
                        Expanded(
                          child: Opacity(
                            opacity:
                                ((collapseT - 0.75) / 0.25).clamp(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.m,
                              ),
                              child: Text(
                                detail.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppBarStyles.title(context).copyWith(
                                  color: context.colors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const Spacer(),

                      SimpleIconButton(
                        icon: SolarIconsOutline.export,
                        onTap: onShare,
                        fillColor: context.ext.surfaceLight,
                        iconColor: context.colors.onSurface,
                        tooltip: 'Share',
                      ),

                      const SizedBox(width: AppSpacing.s),

                      SimpleIconButton(
                        icon: detailVm.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onTap: () {
                          if (detail == null) return;
                          favVm.toggleFavorite(detail.id);
                          detailVm.toggleFavorite();
                        },
                        iconColor: detailVm.isFavorite
                            ? context.colors.error
                            : context.colors.onSurface,
                        fillColor: context.ext.surfaceLight,
                        tooltip: detailVm.isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
