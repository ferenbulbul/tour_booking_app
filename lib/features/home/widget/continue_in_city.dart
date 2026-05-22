import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widget/featured_tour_points.dart';

/// Each section is used as a separate sliver.
/// API call is triggered when the user scrolls down and the section becomes visible.
class LazyCitySection extends StatefulWidget {
  final CityToursSection section;
  const LazyCitySection({super.key, required this.section});

  @override
  State<LazyCitySection> createState() => _LazyCitySectionState();
}

class _LazyCitySectionState extends State<LazyCitySection> {
  static const int _maxVisibleTours = 6;
  bool _fetchTriggered = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_fetchTriggered) return;
    if (info.visibleFraction > 0) {
      _fetchTriggered = true;
      final section = widget.section;
      if (section.tours.isEmpty && !section.isLoading) {
        context.read<HomeViewModel>().fetchCityTours(section.cityId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;

    return VisibilityDetector(
      key: Key('city_visibility_${section.cityId}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + See All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: SectionTitle(
                title: "${tr('continue_in')} ${section.cityName}",
                onMore: () {
                  context.pushNamed(
                    'searchResults',
                    queryParameters: {
                      'type': '1',
                      'cityId': section.cityId,
                      'cityName': section.cityName,
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Content: skeleton or cards
            if (section.isLoading || section.tours.isEmpty)
              _buildSkeleton(context)
            else
              _buildTourList(context, section),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, _) {
          final screenWidth = MediaQuery.of(context).size.width;
          final cardWidth = (screenWidth - AppSpacing.screenPadding * 2 - AppSpacing.m) / 2;
          return Shimmer.fromColors(
            baseColor: context.ext.shimmerBase,
            highlightColor: context.ext.shimmerHighlight,
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: context.ext.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.ml),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTourList(BuildContext context, CityToursSection section) {
    final tours = section.tours;
    final visibleTours = tours.length > _maxVisibleTours
        ? tours.sublist(0, _maxVisibleTours)
        : tours;
    final favVm = context.watch<FavoriteViewModel>();

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - AppSpacing.screenPadding * 2 - AppSpacing.m) / 2;

    return SizedBox(
      height: 220,
      child: ListView.separated(
        key: PageStorageKey("city_tours_${section.cityId}"),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: visibleTours.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final tour = visibleTours[index];
          return FeaturedCard(
            id: tour.id,
            imageUrl: tour.mainImage,
            title: tour.name,
            category: tour.tourTypeName,
            avgRating: tour.avgRating,
            ratingCount: tour.ratingCount,
            durationHours: tour.durationHours,
            durationMinutes: tour.durationMinutes,
            cardWidth: cardWidth,
            imageHeight: 130,
            isFavorite: favVm.isFavorite(tour.id),
            onFavoriteToggle: () => favVm.toggleFavorite(tour.id),
            heroTag: "cityTour_${tour.id}",
            onTap: () {
              context.read<HomeViewModel>().onTourClicked(
                cityId: tour.cityId,
                cityName: tour.cityName,
              );
              context.pushNamed(
                'searchDetail',
                extra: {"id": tour.id, "initialImage": tour.mainImage, "heroTag": "cityTour_${tour.id}"},
              );
            },
          );
        },
      ),
    );
  }
}
