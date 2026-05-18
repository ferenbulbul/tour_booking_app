import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/core/widgets/tour_filter_chips.dart';
import 'package:tour_booking/core/widgets/tour_results_header.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/tour/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';

class AllFeaturedScreen extends StatefulWidget {
  const AllFeaturedScreen({super.key});

  @override
  State<AllFeaturedScreen> createState() => _AllFeaturedScreenState();
}

class _AllFeaturedScreenState extends State<AllFeaturedScreen> {
  String? _selectedCategory;
  String? _selectedDuration;
  String? _selectedRating;

  List<FeaturedTourPointDto> _applyFilters(List<FeaturedTourPointDto> points) {
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

  List<String> _getCategoryOptions(List<FeaturedTourPointDto> points) {
    final types = points.map((p) => p.tourTypeName).toSet().toList();
    types.sort();
    return types;
  }

  @override
  Widget build(BuildContext context) {
    final featuredPoints = context.select<HomeViewModel, List<FeaturedTourPointDto>>((vm) => vm.featuredPoints);
    final filteredPoints = _applyFilters(featuredPoints);
    final categories = _getCategoryOptions(featuredPoints);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TourResultsHeader(
              title: tr("featured_tours"),
            ),

            // FILTER CHIPS
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  FilterChipButton(
                    label: _selectedRating != null ? ratingFilters[_selectedRating]! : "Puan",
                    isActive: _selectedRating != null,
                    onTap: () => showFilterModal(
                      context: context,
                      title: "Puan",
                      options: ratingFilters,
                      selected: _selectedRating,
                      onSelected: (v) => setState(() => _selectedRating = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChipButton(
                    label: _selectedDuration != null ? durationFilters[_selectedDuration]! : "Süre",
                    isActive: _selectedDuration != null,
                    onTap: () => showFilterModal(
                      context: context,
                      title: "Süre",
                      options: durationFilters,
                      selected: _selectedDuration,
                      onSelected: (v) => setState(() => _selectedDuration = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (categories.length > 1)
                    FilterChipButton(
                      label: _selectedCategory ?? "Kategori",
                      isActive: _selectedCategory != null,
                      onTap: () => showFilterModal(
                        context: context,
                        title: "Kategori",
                        options: {for (var c in categories) c: c},
                        selected: _selectedCategory,
                        onSelected: (v) => setState(() => _selectedCategory = v),
                      ),
                    ),
                ],
              ),
            ),

            // RESULT COUNT
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 4, AppSpacing.screenPadding, 8),
              child: Text(
                "${filteredPoints.length} sonuç",
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ),

            // CONTENT
            Expanded(
              child: filteredPoints.isEmpty
                  ? EmptyState(
                      icon: SolarIconsOutline.magnifier,
                      title: tr("search_no_results_title"),
                      subtitle: tr("no_results"),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredPoints.length,
                      itemBuilder: (context, index) {
                        final p = filteredPoints[index];
                        return TourSearchResultCard(
                          id: p.id,
                          imageUrl: p.mainImage,
                          title: p.title,
                          cityId: p.cityId,
                          cityName: p.cityName,
                          avgRating: p.avgRating,
                          ratingCount: p.ratingCount,
                          durationHours: p.durationHours,
                          durationMinutes: p.durationMinutes,
                          heroTag: "allFeatured_${p.id}",
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
