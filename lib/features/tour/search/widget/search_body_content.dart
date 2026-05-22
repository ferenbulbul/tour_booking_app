import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/tour/search/search_viewmodel.dart';
import 'package:tour_booking/features/tour/search/widget/picker_field_skeleton.dart';
import 'package:tour_booking/features/tour/search/widget/toggle_segment.dart';

/// The scrollable body content for the full-page [TourSearchScreen].
/// Contains the header text, toggle selector, and region/city/district pickers.
class SearchBodyContent extends StatelessWidget {
  final int toggleIndex;
  final ValueChanged<int> onToggleChanged;

  const SearchBodyContent({
    super.key,
    required this.toggleIndex,
    required this.onToggleChanged,
  });

  Future<String?> _openPicker(
    BuildContext context, {
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s),

            // HEADER
            Text(
              tr("advanced_search_title"),
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              tr("advanced_search_subtitle"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // TOGGLE
            PremiumToggle(
              index: toggleIndex,
              onChanged: onToggleChanged,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // REGION
            vm.isRegionLoading
                ? const PickerFieldSkeleton()
                : PickerField(
                    label: tr("select_region"),
                    value: _getName(vm.regions, vm.selectedRegionId),
                    icon: SolarIconsOutline.map,
                    hint: tr("region_hint"),
                    onTap: () async {
                      final id = await _openPicker(
                        context,
                        title: tr("region_selection"),
                        icon: SolarIconsOutline.map,
                        list: vm.regions,
                        selected: vm.selectedRegionId,
                      );
                      if (id != null) vm.fetchCities(id);
                    },
                  ),

            const SizedBox(height: AppSpacing.ml),

            // CITY
            vm.isCityLoading
                ? const PickerFieldSkeleton()
                : PickerField(
                    label: tr("select_city"),
                    value: vm.selectedRegionId == null
                        ? null
                        : vm.selectedCityId == null
                            ? tr("all_cities")
                            : _getName(vm.cities, vm.selectedCityId),
                    icon: SolarIconsOutline.buildings_3,
                    hint: tr("city_hint"),
                    onTap: vm.selectedRegionId == null
                        ? () => UIHelper.showWarning(
                            context, tr("region_required"))
                        : () async {
                            final id = await _openPicker(
                              context,
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

            const SizedBox(height: AppSpacing.ml),

            // DISTRICT
            vm.isDistrictLoading
                ? const PickerFieldSkeleton()
                : PickerField(
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
                    icon: SolarIconsOutline.mapPoint,
                    hint: tr("district_hint"),
                    onTap: vm.selectedCityId == null
                        ? () => UIHelper.showWarning(
                            context, tr("city_required"))
                        : () async {
                            final id = await _openPicker(
                              context,
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

            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
