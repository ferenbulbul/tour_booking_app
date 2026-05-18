import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/tour/search/search_viewmodel.dart';
import 'package:tour_booking/features/tour/search/widget/picker_field_skeleton.dart';
import 'package:tour_booking/features/tour/search/widget/toggle_segment.dart';

// ═══════════════════════════════════════════════════════════════
// MODAL — Bottom sheet version of TourSearchScreen
// ═══════════════════════════════════════════════════════════════
Future<void> showTourSearchSheet(BuildContext context) {
  final vm = context.read<SearchViewmodel>();
  if (vm.regions.isEmpty) vm.fetchRegions();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return ChangeNotifierProvider.value(
        value: vm,
        child: const _TourSearchSheet(),
      );
    },
  );
}

class _TourSearchSheet extends StatefulWidget {
  const _TourSearchSheet();

  @override
  State<_TourSearchSheet> createState() => _TourSearchSheetState();
}

class _TourSearchSheetState extends State<_TourSearchSheet> {
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
    final vm = context.watch<SearchViewmodel>();
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // HANDLE
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      SolarIconsOutline.closeCircle,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Text(
              tr("advanced_search_subtitle"),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // TOGGLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: PremiumToggle(
              index: toggleIndex,
              onChanged: (i) => setState(() => toggleIndex = i),
            ),
          ),

          const SizedBox(height: 20),

          // PICKERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              children: [
                // REGION
                vm.isRegionLoading
                    ? const _CompactSkeleton()
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

                const SizedBox(height: 10),

                // CITY
                vm.isCityLoading
                    ? const _CompactSkeleton()
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

                const SizedBox(height: 10),

                // DISTRICT
                vm.isDistrictLoading
                    ? const _CompactSkeleton()
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

          const SizedBox(height: 24),

          // SEARCH BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 16 + bottom,
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(SolarIconsOutline.magnifier, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      tr("search"),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: Colors.white,
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

class _CompactSkeleton extends StatelessWidget {
  const _CompactSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FULL PAGE — TourSearchScreen (kept for deep link / route usage)
// ═══════════════════════════════════════════════════════════════
class TourSearchScreen extends StatefulWidget {
  const TourSearchScreen({super.key});

  @override
  State<TourSearchScreen> createState() => _TourSearchScreenState();
}

class _TourSearchScreenState extends State<TourSearchScreen> {
  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SearchViewmodel>().fetchRegions();
    });
  }

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
    final vm = context.watch<SearchViewmodel>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // BACK BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // HEADER
                      Text(
                        tr("advanced_search_title"),
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr("advanced_search_subtitle"),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // TOGGLE
                      PremiumToggle(
                        index: toggleIndex,
                        onChanged: (i) => setState(() => toggleIndex = i),
                      ),

                      const SizedBox(height: 24),

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
                                  title: tr("region_selection"),
                                  icon: SolarIconsOutline.map,
                                  list: vm.regions,
                                  selected: vm.selectedRegionId,
                                );
                                if (id != null) vm.fetchCities(id);
                              },
                            ),

                      const SizedBox(height: 14),

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

                      const SizedBox(height: 14),

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

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // FIXED BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 16,
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
                    params["regionName"] = _getName(vm.regions, vm.selectedRegionId) ?? "";

                    if (vm.selectedCityId != null) {
                      params["cityId"] = vm.selectedCityId!;
                      params["cityName"] = _getName(vm.cities, vm.selectedCityId) ?? "";
                    }

                    if (vm.selectedDistrictId != null &&
                        vm.selectedDistrictId!.isNotEmpty) {
                      params["districtId"] = vm.selectedDistrictId!;
                      params["districtName"] = _getName(vm.districts, vm.selectedDistrictId) ?? "";
                    }

                    context.pushNamed(
                      "searchResults",
                      queryParameters: params,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(SolarIconsOutline.magnifier, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        tr("search"),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
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
      ),
    );
  }
}
