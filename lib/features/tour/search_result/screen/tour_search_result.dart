import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/core/widgets/tour_filter_chips.dart';
import 'package:tour_booking/core/widgets/tour_results_header.dart';
import 'package:tour_booking/features/home/widget/tour_type_result_skeleton.dart';
import 'package:tour_booking/features/tour/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/tour/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';

class TourSearchResultsScreen extends StatefulWidget {
  final int type;
  final String? regionId;
  final String? cityId;
  final String? districtId;
  final String? regionName;
  final String? cityName;
  final String? districtName;

  const TourSearchResultsScreen({
    super.key,
    required this.type,
    this.regionId,
    this.cityId,
    this.districtId,
    this.regionName,
    this.cityName,
    this.districtName,
  });

  @override
  State<TourSearchResultsScreen> createState() =>
      _TourSearchResultsScreenState();
}

class _TourSearchResultsScreenState extends State<TourSearchResultsScreen> {
  String? _selectedCategory;
  String? _selectedDuration;
  String? _selectedRating;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final req = TourSearchRequest(
        type: widget.type,
        regionId: widget.regionId,
        cityId: widget.cityId,
        districtId: widget.districtId,
      );
      context.read<TourSearchResultsViewModel>().fetchTourPoints(req);
    });
  }

  String get _headerTitle {
    if (widget.cityName != null && widget.cityName!.isNotEmpty) return widget.cityName!;
    if (widget.regionName != null && widget.regionName!.isNotEmpty) return widget.regionName!;
    return tr("tour_search_results_title");
  }

  String get _headerSubtitle {
    final parts = <String>[];
    if (widget.regionName != null && widget.regionName!.isNotEmpty) parts.add(widget.regionName!);
    if (widget.cityName != null && widget.cityName!.isNotEmpty) parts.add(widget.cityName!);
    if (widget.districtName != null && widget.districtName!.isNotEmpty) parts.add(widget.districtName!);
    if (parts.isEmpty) return "";
    return parts.join(" / ");
  }

  List _applyFilters(List points) {
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

  List<String> _getCategoryOptions(List points) {
    final types = points.map((p) => p.tourTypeName as String).toSet().toList();
    types.sort();
    return types;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchResultsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.errorMessage != null) {
        UIHelper.showError(context, vm.errorMessage!);
        vm.clearMessages();
      }
    });

    final filteredPoints = _applyFilters(vm.tourPoints);
    final categories = _getCategoryOptions(vm.tourPoints);

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TourResultsHeader(
              title: _headerTitle,
              subtitle: _headerSubtitle,
              isLoading: vm.isLoading,
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
            if (!vm.isLoading)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.xs, AppSpacing.screenPadding, AppSpacing.s),
                child: Text(
                  tr('filter_result_count', namedArgs: {'count': filteredPoints.length.toString()}),
                  style: AppTextStyles.bodySmall.copyWith(color: context.colors.onSurfaceVariant, fontWeight: FontWeight.w500),
                ),
              ),

            Expanded(child: _buildBody(vm, filteredPoints)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TourSearchResultsViewModel vm, List filteredPoints) {
    if (vm.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.l),
        itemBuilder: (_, __) => const TourCardSkeleton(),
      );
    }

    if (filteredPoints.isEmpty) {
      return EmptyState(
        icon: SolarIconsOutline.magnifier,
        title: tr("search_no_results_title"),
        subtitle: tr("search_no_results_subtitle"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: filteredPoints.length,
      itemBuilder: (_, i) => RepaintBoundary(
        child: TourSearchResultCard(
          id: filteredPoints[i].id,
          imageUrl: filteredPoints[i].mainImage,
          title: filteredPoints[i].name,
          cityId: filteredPoints[i].cityId,
          cityName: filteredPoints[i].cityName,
          districtName: filteredPoints[i].districtName,
          avgRating: filteredPoints[i].avgRating,
          ratingCount: filteredPoints[i].ratingCount,
          durationHours: filteredPoints[i].durationHours,
          durationMinutes: filteredPoints[i].durationMinutes,
        ),
      ),
    );
  }
}
