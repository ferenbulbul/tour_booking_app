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
import 'package:tour_booking/features/home/widget/tour_type_result_skeleton.dart';
import 'package:tour_booking/features/tour/search_result/widget/tour_search_result_card.dart';

class TourSearchResultsByTourTypeScreen extends StatefulWidget {
  final String? tourTypeId;
  final String? tourTypeName;

  const TourSearchResultsByTourTypeScreen({
    super.key,
    required this.tourTypeId,
    this.tourTypeName,
  });

  @override
  State<TourSearchResultsByTourTypeScreen> createState() =>
      _TourSearchResultsByTourTypeScreenState();
}

class _TourSearchResultsByTourTypeScreenState
    extends State<TourSearchResultsByTourTypeScreen> {
  String? _selectedDuration;
  String? _selectedRating;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeViewModel>().fetchTourPointsByType(widget.tourTypeId ?? "");
    });
  }

  List _applyFilters(List items) {
    var result = items.toList();
    if (_selectedDuration != null) {
      result = result.where((p) => matchesDurationFilter(_selectedDuration, p.durationHours, p.durationMinutes)).toList();
    }
    if (_selectedRating != null) {
      result = result.where((p) => matchesRatingFilter(_selectedRating, p.avgRating)).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoadingSearchByType);
    final items = context.select<HomeViewModel, List>((vm) => vm.searchItemsByType);
    final msg = context.select<HomeViewModel, String?>((vm) => vm.messageSearchByType);
    final filteredItems = _applyFilters(items);

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TourResultsHeader(
              title: widget.tourTypeName ?? tr("tour_search_results_title"),
              subtitle: tr("categories"),
              isLoading: isLoading,
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
                ],
              ),
            ),

            // RESULT COUNT
            if (!isLoading)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.xs, AppSpacing.screenPadding, AppSpacing.s),
                child: Text(
                  tr('filter_result_count', namedArgs: {'count': filteredItems.length.toString()}),
                  style: AppTextStyles.bodySmall.copyWith(color: context.colors.onSurfaceVariant, fontWeight: FontWeight.w500),
                ),
              ),

            Expanded(child: _buildBody(isLoading, msg, filteredItems)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isLoading, String? msg, List items) {
    if (isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.m),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.l),
        itemBuilder: (_, __) => const TourCardSkeleton(),
      );
    }

    if (msg != null) {
      return EmptyState(icon: SolarIconsOutline.infoCircle, title: tr("search_no_results_title"), subtitle: msg);
    }

    if (items.isEmpty) {
      return EmptyState(icon: SolarIconsOutline.magnifier, title: tr("search_no_results_title"), subtitle: tr("no_tour_matching_criteria"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: items.length,
      itemBuilder: (_, i) => RepaintBoundary(
        child: TourSearchResultCard(
          id: items[i].id,
          imageUrl: items[i].mainImage,
          title: items[i].name,
          cityId: items[i].cityId,
          cityName: items[i].cityName,
          districtName: items[i].districtName,
          avgRating: items[i].avgRating,
          ratingCount: items[i].ratingCount,
          durationHours: items[i].durationHours,
          durationMinutes: items[i].durationMinutes,
        ),
      ),
    );
  }
}
