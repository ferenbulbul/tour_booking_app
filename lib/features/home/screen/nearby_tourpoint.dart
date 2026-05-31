import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/core/widgets/tour_filter_chips.dart';
import 'package:tour_booking/core/widgets/tour_results_header.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/features/home/widget/nearby_skeleton.dart';
import 'package:tour_booking/features/tour/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/nearby_tourpoint/nearby_tour_point_dto.dart';

class NearbyPointsScreen extends StatefulWidget {
  const NearbyPointsScreen({super.key});

  @override
  State<NearbyPointsScreen> createState() => _NearbyPointsScreenState();
}

class _NearbyPointsScreenState extends State<NearbyPointsScreen> {
  String? _selectedCategory;
  String? _selectedDuration;
  String? _selectedRating;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locVm = context.read<LocationViewModel>();
      final homeVm = context.read<HomeViewModel>();

      // Force send location to server when entering Nearby page
      await locVm.sendLocationUpdate();

      if (!mounted) return;
      final pos = locVm.currentPosition;
      if (pos != null) {
        homeVm.fetchNearbyTourPoints(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      }
    });
  }

  List<NearbyTourPointDto> _applyFilters(List<NearbyTourPointDto> points) {
    var result = points.toList();
    if (_selectedCategory != null) {
      result = result.where((p) => p.tourTypeName == _selectedCategory).toList();
    }
    if (_selectedDuration != null) {
      result = result.where((p) => matchesDurationFilter(_selectedDuration, p.durationHours, p.durationMinutes)).toList();
    }
    if (_selectedRating != null) {
      result = result.where((p) => matchesRatingFilter(_selectedRating, p.avgRating)).toList();
    }
    return result;
  }

  List<String> _getCategoryOptions(List<NearbyTourPointDto> points) {
    final types = points.map((p) => p.tourTypeName).toSet().toList();
    types.sort();
    return types;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final filteredPoints = _applyFilters(vm.nearbyPoints);
    final categories = _getCategoryOptions(vm.nearbyPoints);

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            TourResultsHeader(
              title: tr("nearby_tours"),
              subtitle: tr("find_tours_nearby"),
              isLoading: vm.isLoadingNearby,
            ),

            // FILTER CHIPS
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.s),
              child: Row(
                children: [
                  FilterChipButton(
                    label: _selectedRating != null ? ratingFilters[_selectedRating]! : tr('filter_rating'),
                    isActive: _selectedRating != null,
                    onTap: () => showFilterModal(
                      context: context,
                      title: tr('filter_rating'),
                      options: ratingFilters,
                      selected: _selectedRating,
                      onSelected: (v) => setState(() => _selectedRating = v),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  FilterChipButton(
                    label: _selectedDuration != null ? durationFilters[_selectedDuration]! : tr('filter_duration'),
                    isActive: _selectedDuration != null,
                    onTap: () => showFilterModal(
                      context: context,
                      title: tr('filter_duration'),
                      options: durationFilters,
                      selected: _selectedDuration,
                      onSelected: (v) => setState(() => _selectedDuration = v),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  if (categories.length > 1)
                    FilterChipButton(
                      label: _selectedCategory ?? tr('category'),
                      isActive: _selectedCategory != null,
                      onTap: () => showFilterModal(
                        context: context,
                        title: tr('category'),
                        options: {for (var c in categories) c: c},
                        selected: _selectedCategory,
                        onSelected: (v) => setState(() => _selectedCategory = v),
                      ),
                    ),
                ],
              ),
            ),

            // RESULT COUNT
            if (!vm.isLoadingNearby)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, 4, AppSpacing.screenPadding, 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('filter_result_count', namedArgs: {'count': filteredPoints.length.toString()}),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // CONTENT
            Expanded(child: _buildBody(vm, filteredPoints)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(HomeViewModel vm, List<NearbyTourPointDto> filteredPoints) {
    if (vm.isLoadingNearby) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sectionSpacing,
        ),
        child: NearbySkeleton(),
      );
    }

    if (filteredPoints.isEmpty) {
      return EmptyState(
        icon: SolarIconsOutline.mapPointRemove,
        title: tr("no_nearby_tour_found"),
        subtitle: tr("no_nearby_tour_found_subtitle"),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        final pos = context.read<LocationViewModel>().currentPosition;
        if (pos == null) return Future.value();
        return vm.fetchNearbyTourPoints(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: filteredPoints.length,
        itemBuilder: (_, i) {
          final p = filteredPoints[i];
          return TourSearchResultCard(
            id: p.id,
            imageUrl: p.mainImage,
            title: p.title,
            cityName: p.cityName,
            avgRating: p.avgRating,
            ratingCount: p.ratingCount,
            durationHours: p.durationHours,
            durationMinutes: p.durationMinutes,
            heroTag: "nearby_${p.id}",
          );
        },
      ),
    );
  }
}
