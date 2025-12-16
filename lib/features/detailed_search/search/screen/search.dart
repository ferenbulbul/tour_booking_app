import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/detailed_search/search/search_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search/widget/picker_field_skleleton.dart';
import 'package:tour_booking/features/detailed_search/search/widget/toggle_segment.dart';

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

  // ---------------------------------------------------------------------------

  Future<String?> _openPicker({
    required String title,
    required List list,
    required String? selected,
    bool includeAll = false,
    String? allLabel,
  }) {
    final options = [
      if (includeAll) PickerOption("", allLabel ?? "Tümü"),
      ...list.map((e) => PickerOption(e.id, e.name)),
    ];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) {
        return PickerSheet(title: title, options: options, initialId: selected);
      },
    );
  }

  // ---------------------------------------------------------------------------

  String? _getName(List list, String? id) {
    if (id == null) return null;
    for (var e in list) {
      if (e.id == id) return e.name;
    }
    return null;
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewmodel>();
    final scheme = Theme.of(context).colorScheme;
    final showCities = vm.selectedRegionId != null;
    final showDistricts =
        vm.selectedRegionId != null && vm.selectedCityId != null;

    return Scaffold(
      backgroundColor: scheme.surface,

      // APP BAR ---------------------------------------------------------
      appBar: CommonAppBar(title: "Detaylı Arama", showBack: false),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520, // 🔥 kritik: sayfayı “ortalanmış” hissettirir
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TOGGLE -----------------------------------------------------
                  PremiumToggle(
                    index: toggleIndex,
                    onChanged: (i) => setState(() => toggleIndex = i),
                  ),

                  const SizedBox(height: 32),

                  // REGION (BÖLGE) --------------------------------------------
                  vm.isRegionLoading
                      ? const PickerFieldSkeleton()
                      : PickerField(
                          label: "Bölge Seçin",
                          value: _getName(vm.regions, vm.selectedRegionId),
                          icon: Icons.map_outlined,
                          onTap: () async {
                            final id = await _openPicker(
                              title: "Bölge Seçimi",
                              list: vm.regions,
                              selected: vm.selectedRegionId,
                            );

                            if (id != null) vm.fetchCities(id);
                          },
                        ),

                  const SizedBox(height: 20),

                  // CITY (İL) --------------------------------------------------
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showCities
                        ? Column(
                            key: const ValueKey("city_field"),
                            children: [
                              vm.isCityLoading
                                  ? const PickerFieldSkeleton()
                                  : PickerField(
                                      label: "İl Seçin",
                                      value: vm.selectedCityId == null
                                          ? "Tüm İller"
                                          : _getName(
                                              vm.cities,
                                              vm.selectedCityId,
                                            ),
                                      icon: Icons.location_city_outlined,
                                      onTap: () async {
                                        final id = await _openPicker(
                                          title: "İl Seçimi",
                                          list: vm.cities,
                                          selected: vm.selectedCityId,
                                          includeAll: true,
                                          allLabel: "Tüm İller",
                                        );

                                        if (id != null) {
                                          if (id.isEmpty) {
                                            vm.selectedCityId = null;
                                            vm.selectedDistrictId = null;
                                            vm.districts = [];
                                            vm.notifyListeners();
                                          } else {
                                            vm.fetchDistricts(id);
                                          }
                                        }
                                      },
                                    ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  // DISTRICT (İLÇE) --------------------------------------------
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showDistricts
                        ? Column(
                            key: const ValueKey("district_field"),
                            children: [
                              vm.isDistrictLoading
                                  ? const PickerFieldSkeleton()
                                  : PickerField(
                                      label: "İlçe Seçin",
                                      value:
                                          vm.selectedDistrictId == null ||
                                              vm.selectedDistrictId!.isEmpty
                                          ? "Tüm İlçeler"
                                          : _getName(
                                              vm.districts,
                                              vm.selectedDistrictId,
                                            ),
                                      icon: Icons.location_on_outlined,
                                      onTap: () async {
                                        final id = await _openPicker(
                                          title: "İlçe Seçimi",
                                          list: vm.districts,
                                          selected: vm.selectedDistrictId,
                                          includeAll: true,
                                          allLabel: "Tüm İlçeler",
                                        );
                                        if (id != null) vm.selectDistrict(id);
                                      },
                                    ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 16),

                  // SEARCH BUTTON ---------------------------------------------
                  SizedBox(
                    height: 54,
                    child: PrimaryButton(
                      text: "Ara",
                      onPressed: () {
                        if (vm.selectedRegionId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen bir bölge seçin."),
                            ),
                          );
                          return;
                        }

                        final params = {"type": toggleIndex.toString()};
                        params["regionId"] = vm.selectedRegionId!;

                        if (vm.selectedCityId != null) {
                          params["cityId"] = vm.selectedCityId!;
                        }

                        if (vm.selectedDistrictId != null &&
                            vm.selectedDistrictId!.isNotEmpty) {
                          params["districtId"] = vm.selectedDistrictId!;
                        }

                        context.pushNamed(
                          "searchResults",
                          queryParameters: params,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
