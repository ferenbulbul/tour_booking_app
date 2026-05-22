import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/tour/search/search_viewmodel.dart';
import 'package:tour_booking/features/tour/search/widget/toggle_segment.dart';

class TourSearchSheetContent extends StatefulWidget {
  const TourSearchSheetContent({super.key});

  @override
  State<TourSearchSheetContent> createState() => _TourSearchSheetContentState();
}

class _TourSearchSheetContentState extends State<TourSearchSheetContent> {
  int toggleIndex = 0;

  Future<String?> _openPicker({
    required String title,
    required List list,
    required String? selected,
    IconData icon = SolarIconsOutline.buildings_3,
    bool includeAll = false,
    String? allLabel,
  }) {
    final options = [
      if (includeAll) PickerOption("", allLabel ?? ""),
      ...list.map((e) => PickerOption(e.id, e.name)),
    ];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) {
        return PickerSheet(title: title, icon: icon, options: options, initialId: selected);
      },
    );
  }

  String? _getName(List list, String? id) {
    if (id == null) return null;
    for (var e in list) {
      if (e.id == id) return e.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.ms),

          // HANDLE
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outline,
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tr("advanced_search_title"),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Close search',
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        SolarIconsOutline.closeCircle,
                        size: AppIconSize.ml,
                        color: context.colors.onSurfaceVariant,
                        semanticLabel: 'Close',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Text(
              tr("advanced_search_subtitle"),
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // TOGGLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: PremiumToggle(
              index: toggleIndex,
              onChanged: (i) => setState(() => toggleIndex = i),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // PICKERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              children: [
                // REGION
                vm.isRegionLoading
                    ? const CompactSkeleton()
                    : CompactPickerField(
                        icon: SolarIconsOutline.map,
                        label: tr("select_region"),
                        value: _getName(vm.regions, vm.selectedRegionId),
                        onTap: () async {
                          final id = await _openPicker(
                            title: tr("region_selection"),
                            icon: SolarIconsOutline.map,
                            list: vm.regions,
                            selected: vm.selectedRegionId,
                          );
                          if (id != null) vm.fetchCities(id);
                        },
                      ),

                const SizedBox(height: AppSpacing.ms),

                // CITY
                vm.isCityLoading
                    ? const CompactSkeleton()
                    : CompactPickerField(
                        icon: SolarIconsOutline.buildings_3,
                        label: tr("select_city"),
                        value: vm.selectedRegionId == null
                            ? null
                            : vm.selectedCityId == null
                                ? tr("all_cities")
                                : _getName(vm.cities, vm.selectedCityId),
                        onTap: vm.selectedRegionId == null
                            ? () => UIHelper.showWarning(
                                context, tr("region_required"))
                            : () async {
                                final id = await _openPicker(
                                  title: tr("city_selection"),
                                  icon: SolarIconsOutline.buildings_3,
                                  list: vm.cities,
                                  selected: vm.selectedCityId,
                                  includeAll: true,
                                  allLabel: tr("all_cities"),
                                );
                                if (id != null) {
                                  if (id.isEmpty) {
                                    vm.clearCitySelection();
                                  } else {
                                    vm.fetchDistricts(id);
                                  }
                                }
                              },
                      ),

                const SizedBox(height: AppSpacing.ms),

                // DISTRICT
                vm.isDistrictLoading
                    ? const CompactSkeleton()
                    : CompactPickerField(
                        icon: SolarIconsOutline.mapPoint,
                        label: tr("select_district"),
                        value: vm.selectedCityId == null
                            ? null
                            : vm.selectedDistrictId == null ||
                                    vm.selectedDistrictId!.isEmpty
                                ? tr("all_districts")
                                : _getName(
                                    vm.districts,
                                    vm.selectedDistrictId,
                                  ),
                        onTap: vm.selectedCityId == null
                            ? () => UIHelper.showWarning(
                                context, tr("city_required"))
                            : () async {
                                final id = await _openPicker(
                                  title: tr("district_selection"),
                                  icon: SolarIconsOutline.mapPoint,
                                  list: vm.districts,
                                  selected: vm.selectedDistrictId,
                                  includeAll: true,
                                  allLabel: tr("all_districts"),
                                );
                                if (id != null) vm.selectDistrict(id);
                              },
                      ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // SEARCH BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.l + bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (vm.selectedRegionId == null) {
                    UIHelper.showWarning(context, tr("region_required"));
                    return;
                  }

                  final params = {"type": toggleIndex.toString()};
                  params["regionId"] = vm.selectedRegionId!;
                  params["regionName"] =
                      _getName(vm.regions, vm.selectedRegionId) ?? "";

                  if (vm.selectedCityId != null) {
                    params["cityId"] = vm.selectedCityId!;
                    params["cityName"] =
                        _getName(vm.cities, vm.selectedCityId) ?? "";
                  }

                  if (vm.selectedDistrictId != null &&
                      vm.selectedDistrictId!.isNotEmpty) {
                    params["districtId"] = vm.selectedDistrictId!;
                    params["districtName"] =
                        _getName(vm.districts, vm.selectedDistrictId) ?? "";
                  }

                  Navigator.pop(context);
                  context.pushNamed(
                    "searchResults",
                    queryParameters: params,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onSecondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(SolarIconsOutline.magnifier, size: AppIconSize.l, semanticLabel: 'Search'),
                    const SizedBox(width: AppSpacing.ms),
                    Text(
                      tr("search"),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: context.colors.onSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompactSkeleton extends StatelessWidget {
  const CompactSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.outline.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
      ),
    );
  }
}
