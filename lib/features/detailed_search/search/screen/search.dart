import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/detailed_search/search/search_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search/widget/toggle_segment.dart';

class TourSearchScreen extends StatefulWidget {
  const TourSearchScreen({super.key});

  @override
  State<TourSearchScreen> createState() => _TourSearchScreenState();
}

class _TourSearchScreenState extends State<TourSearchScreen>
    with SingleTickerProviderStateMixin {
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

    // ⭐ ekstra parametre: "Tüm ..." seçeneği eklensin mi?
    bool includeAll = false,
    String? allLabel,
  }) {
    // ⭐ seçenekleri oluştur
    final options = [
      if (includeAll) PickerOption("", allLabel ?? "Tümü"),
      ...list.map((e) => PickerOption(e.id, e.name)),
    ];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return PickerSheet(
              title: title,
              initialId: selected,
              options: options,
              controller: scrollController,
            );
          },
        );
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

    final bool showCities = vm.selectedRegionId != null;
    final bool showDistricts =
        vm.selectedRegionId != null && vm.selectedCityId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Detaylı Arama"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumToggle(
              index: toggleIndex,
              onChanged: (i) => setState(() => toggleIndex = i),
            ),

            const SizedBox(height: 26),

            // ⭐ BÖLGE
            PickerField(
              label: "Bölge Seçin",
              glass: true,
              value: _getName(vm.regions, vm.selectedRegionId),
              icon: Icons.map_outlined,
              onTap: () async {
                final id = await _openPicker(
                  title: "Bölge",
                  list: vm.regions,
                  selected: vm.selectedRegionId,
                );
                if (id != null) vm.fetchCities(id);
              },
            ),

            const SizedBox(height: 20),

            // ⭐ İL (ANİMASYONLU)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                );
              },
              child: showCities
                  ? Column(
                      key: const ValueKey("cities"),
                      children: [
                        PickerField(
                          label: "İl Seçin",
                          glass: true,
                          value: vm.selectedCityId == null
                              ? "Tüm İller"
                              : _getName(vm.cities, vm.selectedCityId),
                          icon: Icons.location_city,
                          onTap: () async {
                            final id = await _openPicker(
                              title: "İl",
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

            // ⭐ İLÇE (ANİMASYONLU)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                );
              },
              child: showDistricts
                  ? Column(
                      key: const ValueKey("districts"),
                      children: [
                        PickerField(
                          label: "İlçe Seçin",
                          glass: true,
                          value:
                              vm.selectedDistrictId == null ||
                                  vm.selectedDistrictId!.isEmpty
                              ? "Tüm İlçeler"
                              : _getName(vm.districts, vm.selectedDistrictId),
                          icon: Icons.location_on,
                          onTap: () async {
                            final id = await _openPicker(
                              title: "İlçe",
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

            const SizedBox(height: 10),

            // 🔍 Ara
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (vm.selectedRegionId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen bir bölge seçin."),
                        backgroundColor: Colors.red,
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

                  context.pushNamed("searchResults", queryParameters: params);
                },
                child: const Text(
                  "Ara",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
