import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class _CityData {
  final String name;
  final String subtitleKey;
  final String imageUrl;
  final String cityId;

  const _CityData({
    required this.name,
    required this.subtitleKey,
    required this.imageUrl,
    required this.cityId,
  });
}

const _cities = [
  _CityData(
    name: 'İstanbul',
    subtitleKey: 'city_subtitle_istanbul',
    imageUrl: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=600',
    cityId: '',
  ),
  _CityData(
    name: 'Antalya',
    subtitleKey: 'city_subtitle_antalya',
    imageUrl: 'https://images.unsplash.com/photo-1593238739364-18cfde865992?w=600',
    cityId: '',
  ),
  _CityData(
    name: 'Kapadokya',
    subtitleKey: 'city_subtitle_cappadocia',
    imageUrl: 'https://images.unsplash.com/photo-1641128324972-af3212f0f6bd?w=600',
    cityId: '',
  ),
  _CityData(
    name: 'İzmir',
    subtitleKey: 'city_subtitle_istanbul',
    imageUrl: 'https://images.unsplash.com/photo-1590076084383-bfdb09de628a?w=600',
    cityId: '',
  ),
  _CityData(
    name: 'Bodrum',
    subtitleKey: 'city_subtitle_bodrum',
    imageUrl: 'https://images.unsplash.com/photo-1614587185092-af24d327c858?w=600',
    cityId: '',
  ),
  _CityData(
    name: 'Trabzon',
    subtitleKey: 'city_subtitle_trabzon',
    imageUrl: 'https://images.unsplash.com/photo-1571935281914-d898e1e8f104?w=600',
    cityId: '',
  ),
];

class PopularCitiesWidget extends StatelessWidget {
  const PopularCitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        key: const PageStorageKey("popular_cities"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: _cities.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final city = _cities[index];
          return _CityCard(
            name: city.name,
            subtitle: tr(city.subtitleKey),
            imageUrl: city.imageUrl,
            onTap: () {
              // TODO: search tours by city
            },
          );
        },
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _CityCard({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: name,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Expanded(
                child: Semantics(
                  image: true,
                  label: name,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      memCacheWidth: 400,
                      fadeInDuration: const Duration(milliseconds: 150),
                      placeholder: (_, __) => Container(
                        color: context.colors.surfaceContainerHighest,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: context.colors.primaryContainer,
                        child: Icon(SolarIconsOutline.gallery, color: Colors.white.withValues(alpha: 0.54), semanticLabel: 'Image placeholder'),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s),

              // NAME
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelLarge.copyWith(
                  color: context.colors.onSurface,
                ),
              ),

              const SizedBox(height: AppSpacing.xxs),

              // SUBTITLE
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.ext.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
