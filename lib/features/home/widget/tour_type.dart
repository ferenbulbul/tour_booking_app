import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widget/tour_type_skeleton.dart';
import 'package:tour_booking/models/tour_type/tour_type_dto.dart';

class TourTypeWidget extends StatefulWidget {
  const TourTypeWidget({super.key});

  @override
  State<TourTypeWidget> createState() => _TourTypeWidgetState();
}

class _TourTypeWidgetState extends State<TourTypeWidget> {
  bool _fetchTriggered = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_fetchTriggered) return;
    if (info.visibleFraction > 0) {
      _fetchTriggered = true;
      final vm = context.read<HomeViewModel>();
      if (vm.tourTypes.isEmpty) {
        vm.fetchTourTypes();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoadingTourTypes);
    final tourTypes = context.select<HomeViewModel, List<TourTypeDto>>((vm) => vm.tourTypes);
    final message = context.select<HomeViewModel, String?>((vm) => vm.tourTypesMessage);

    return VisibilityDetector(
      key: const Key('tour_types_visibility'),
      onVisibilityChanged: _onVisibilityChanged,
      child: _buildContent(isLoading, tourTypes, message),
    );
  }

  Widget _buildContent(bool isLoading, List<TourTypeDto> tourTypes, String? message) {
    if (isLoading || (!_fetchTriggered && tourTypes.isEmpty)) {
      return const CategoryCardSkeleton();
    }

    if (message != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Text(message),
      );
    }

    if (tourTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        key: const PageStorageKey("category_list"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: tourTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final item = tourTypes[index];
          return _CategoryCard(
            title: item.title,
            description: item.description,
            imageUrl: item.thumbImageUrl,
            onTap: () => context.pushNamed(
              'tourSearchByType',
              queryParameters: {
                'tourTypeId': item.id,
                'tourTypeName': item.title,
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    const double cardWidth = 220;
    final targetWidth = (cardWidth * dpr).round();

    return SizedBox(
      width: cardWidth,
      child: Semantics(
        button: true,
        label: title,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Semantics(
              image: true,
              label: title,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.small),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: targetWidth,
                    maxWidthDiskCache: targetWidth,
                    fadeInDuration: const Duration(milliseconds: 180),
                    placeholder: (_, __) => Container(color: context.colors.surfaceContainerHighest),
                    errorWidget: (_, __, ___) => Container(
                      color: context.colors.surfaceContainerHighest,
                      child: Icon(SolarIconsOutline.gallery, color: context.ext.textLight, semanticLabel: 'Image placeholder'),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s),

            // TITLE
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleSmall.copyWith(
                color: context.colors.onSurface,
              ),
            ),

            // DESCRIPTION
            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}
