import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';

class PopularCitiesWidget extends StatelessWidget {
  const PopularCitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth - AppSpacing.screenPadding * 2 - AppSpacing.m) / 2;

        // Loading state
        if (vm.isLoadingPopularDestinations) {
          return SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
              itemBuilder: (context, _) {
                return Shimmer.fromColors(
                  baseColor: context.ext.shimmerBase,
                  highlightColor: context.ext.shimmerHighlight,
                  child: SizedBox(
                    width: cardWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image placeholder
                          Container(color: context.ext.shimmerBase),

                          // Gradient overlay (matches actual card)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 70,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.15),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // City name placeholder
                          Positioned(
                            left: AppSpacing.m,
                            right: AppSpacing.m,
                            bottom: AppSpacing.m,
                            child: Container(
                              height: 14,
                              width: 80,
                              decoration: BoxDecoration(
                                color: context.ext.shimmerBase,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xxs),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Empty state
        if (vm.popularDestinations.isEmpty) {
          return const SizedBox.shrink();
        }

        // Data loaded
        return SizedBox(
          height: 170,
          child: ListView.separated(
            key: const PageStorageKey("popular_cities"),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: vm.popularDestinations.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, index) {
              final destination = vm.popularDestinations[index];
              final name = destination.districtName ?? destination.cityName ?? '';

              return _PopularCityCard(
                name: name,
                imageUrl: destination.imageUrl,
                cardWidth: cardWidth,
                onTap: () {
                  final params = <String, String>{'type': '1'};
                  if (destination.cityId != null) {
                    params['cityId'] = destination.cityId!;
                    params['cityName'] = destination.cityName ?? '';
                  }
                  if (destination.districtId != null) {
                    params['districtId'] = destination.districtId!;
                    params['districtName'] = destination.districtName ?? '';
                  }
                  context.pushNamed('searchResults', queryParameters: params);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _PopularCityCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double cardWidth;
  final VoidCallback onTap;

  const _PopularCityCard({
    required this.name,
    required this.imageUrl,
    required this.cardWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final targetWidth = (cardWidth * dpr).round();

    return Semantics(
      button: true,
      label: name,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: cardWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMAGE
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: targetWidth,
                  maxWidthDiskCache: targetWidth,
                  fadeInDuration: const Duration(milliseconds: 150),
                  placeholder: (_, __) => Container(
                    color: context.colors.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: context.colors.primaryContainer,
                    child: Icon(
                      SolarIconsOutline.gallery,
                      color: Colors.white.withValues(alpha: 0.54),
                      semanticLabel: 'Image placeholder',
                    ),
                  ),
                ),

                // GRADIENT OVERLAY
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 70,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                ),

                // CITY NAME
                Positioned(
                  left: AppSpacing.m,
                  right: AppSpacing.m,
                  bottom: AppSpacing.m,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
