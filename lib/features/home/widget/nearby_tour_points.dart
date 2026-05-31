import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widget/featured_card_skeleton.dart';
import 'package:tour_booking/features/home/widget/featured_tour_points.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/models/nearby_tourpoint/nearby_tour_point_dto.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';

class NearbyTourPointsWidget extends StatelessWidget {
  const NearbyTourPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionStatus = context.select<LocationViewModel, LocationPermissionStatus?>(
      (vm) => vm.permissionStatus,
    );
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoadingNearby);
    final nearbyPoints = context.select<HomeViewModel, List<NearbyTourPointDto>>(
      (vm) => vm.nearbyPoints,
    );

    // Hide if no location permission
    final hasPermission = permissionStatus == LocationPermissionStatus.grantedAlways ||
        permissionStatus == LocationPermissionStatus.grantedWhenInUse;

    if (!hasPermission && !isLoading) return const SizedBox.shrink();
    if (!isLoading && nearbyPoints.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sectionSpacing),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: SectionTitle(
            title: tr("nearby_tours"),
            onMore: () => context.pushNamed('nearbyPoints'),
          ),
        ),
        const SizedBox(height: AppSpacing.m),

        // Cards
        if (isLoading)
          const _NearbyLoadingSkeleton()
        else
          _NearbyCardList(points: nearbyPoints),
      ],
    );
  }
}

class _NearbyCardList extends StatelessWidget {
  final List<NearbyTourPointDto> points;
  const _NearbyCardList({required this.points});

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - AppSpacing.screenPadding * 2 - AppSpacing.m * 2) / 3;
    const imageHeight = 120.0;

    return SizedBox(
      height: 210,
      child: ListView.separated(
        key: const PageStorageKey("nearby_list"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: points.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final p = points[index];

          return FeaturedCard(
            id: p.id,
            imageUrl: p.mainImage,
            title: p.title,
            category: p.tourTypeName,
            avgRating: p.avgRating,
            ratingCount: p.ratingCount,
            durationHours: p.durationHours,
            durationMinutes: p.durationMinutes,
            heroTag: "nearby_${p.id}",
            cardWidth: cardWidth,
            imageHeight: imageHeight,
            isFavorite: favVm.isFavorite(p.id),
            onFavoriteToggle: () => favVm.toggleFavorite(p.id),
            onTap: () => context.pushNamed(
              'searchDetail',
              extra: {"id": p.id, "initialImage": p.mainImage, "heroTag": "nearby_${p.id}"},
            ),
          );
        },
      ),
    );
  }
}

class _NearbyLoadingSkeleton extends StatelessWidget {
  const _NearbyLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - AppSpacing.screenPadding * 2 - AppSpacing.m * 2) / 3;

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (_, __) => SizedBox(
          width: cardWidth,
          child: const FeaturedCardSkeleton(),
        ),
      ),
    );
  }
}
