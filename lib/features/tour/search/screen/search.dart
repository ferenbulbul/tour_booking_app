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
import 'package:tour_booking/features/tour/search/search_viewmodel.dart';
import 'package:tour_booking/features/tour/search/widget/search_filter_panel.dart';
import 'package:tour_booking/features/tour/search/widget/search_body_content.dart';

// ===================================================================
// MODAL -- Bottom sheet version of TourSearchScreen
// ===================================================================
Future<void> showTourSearchSheet(BuildContext context) {
  final vm = context.read<SearchViewModel>();
  if (vm.regions.isEmpty) vm.fetchRegions();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return ChangeNotifierProvider.value(
        value: vm,
        child: const TourSearchSheetContent(),
      );
    },
  );
}

// ===================================================================
// FULL PAGE -- TourSearchScreen (kept for deep link / route usage)
// ===================================================================
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
      context.read<SearchViewModel>().fetchRegions();
    });
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

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // BACK BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.s, AppSpacing.l, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: AppIconSize.l, semanticLabel: 'Go back'),
                  ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SearchBodyContent(
                toggleIndex: toggleIndex,
                onToggleChanged: (i) => setState(() => toggleIndex = i),
              ),
            ),

            // FIXED BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.l,
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
      ),
    );
  }
}
