import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/detailed_search/search/search_viewmodel.dart';

class TourSearchScreen extends StatefulWidget {
  const TourSearchScreen({super.key});

  @override
  State<TourSearchScreen> createState() => _TourSearchScreenState();
}

class _TourSearchScreenState extends State<TourSearchScreen> {
  int _selectedToggleIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SearchViewmodel>().fetchRegions();
    });
  }

  void _submit(SearchViewmodel vm) {
    if (vm.selectedRegionId == null || vm.selectedRegionId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen bir bölge seçin."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final params = <String, String>{"type": _selectedToggleIndex.toString()};

    if (vm.selectedRegionId != null) params["regionId"] = vm.selectedRegionId!;
    if (vm.selectedCityId != null) params["cityId"] = vm.selectedCityId!;
    if (vm.selectedDistrictId != null && vm.selectedDistrictId!.isNotEmpty) {
      params["districtId"] = vm.selectedDistrictId!;
    }

    context.pushNamed("searchResults", queryParameters: params);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewmodel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          "Detaylı Arama",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ⭐ TOGGLE
            ToggleSwitch(
              borderWidth: 3,
              borderColor: [Colors.grey.shade400],
              animationDuration: 200,
              minWidth: double.infinity,
              minHeight: 60,
              initialLabelIndex: _selectedToggleIndex,
              cornerRadius: 90,
              totalSwitches: 2,
              icons: const [Icons.my_location, Icons.location_on_outlined],
              labels: const ["Kalkış Noktası", "Tur Noktası"],
              activeFgColor: Colors.white,
              inactiveFgColor: Colors.white,
              inactiveBgColor: Colors.grey.shade400,
              iconSize: 26,
              activeBgColors: const [
                [AppColors.primary, Color(0xFF6089FF)],
                [AppColors.primary, Color(0xFF6089FF)],
              ],
              onToggle: (index) {
                setState(() => _selectedToggleIndex = index ?? 0);
              },
            ),

            const SizedBox(height: 26),

            // ⭐ BÖLGE ---------------------------------------------------------
            if (vm.isRegionLoading)
              const LinearProgressIndicator(color: AppColors.primary)
            else
              _GlassField(
                label: "Bölge Seçin",
                value: _getName(vm.regions, vm.selectedRegionId),
                icon: Icons.map_outlined,
                onTap: () async {
                  final id = await _openPicker(
                    "Bölge Seçin",
                    vm.regions.map((e) => _Option(e.id, e.name)).toList(),
                    vm.selectedRegionId,
                  );
                  if (id != null) vm.fetchCities(id);
                },
              ),

            const SizedBox(height: 16),

            // ⭐ İL -------------------------------------------------------------
            if (vm.isCityLoading)
              const LinearProgressIndicator(color: AppColors.primary)
            else
              _GlassField(
                label: "İl Seçin",
                value: vm.selectedCityId == null
                    ? "Tüm İller"
                    : _getName(vm.cities, vm.selectedCityId),
                icon: Icons.location_city_outlined,
                onTap: () async {
                  final opts = [
                    const _Option("", "Tüm İller"),
                    ...vm.cities.map((e) => _Option(e.id, e.name)),
                  ];

                  final id = await _openPicker(
                    "İl Seçin",
                    opts,
                    vm.selectedCityId ?? "",
                  );

                  if (id != null) {
                    if (id.isEmpty) {
                      vm.selectedCityId = null;
                      vm.selectedDistrictId = null;
                      vm.districts.clear();
                      vm.notifyListeners();
                    } else {
                      vm.fetchDistricts(id);
                    }
                  }
                },
              ),

            const SizedBox(height: 16),

            // ⭐ İLÇE -----------------------------------------------------------
            if (vm.isDistrictLoading)
              const LinearProgressIndicator(color: AppColors.primary)
            else
              _GlassField(
                label: "İlçe Seçin",
                value:
                    vm.selectedDistrictId == null ||
                        vm.selectedDistrictId!.isEmpty
                    ? "Tüm İlçeler"
                    : _getName(vm.districts, vm.selectedDistrictId),
                icon: Icons.location_on_outlined,
                onTap: () async {
                  final opts = [
                    const _Option("", "Tüm İlçeler"),
                    ...vm.districts.map((e) => _Option(e.id, e.name)),
                  ];

                  final id = await _openPicker(
                    "İlçe Seçin",
                    opts,
                    vm.selectedDistrictId,
                  );

                  if (id != null) vm.selectDistrict(id);
                },
              ),

            const SizedBox(height: 28),

            // ⭐ ARA BUTONU ------------------------------------------------------
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _submit(vm),
                child: const Text(
                  "Ara",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Future<String?> _openPicker(
    String title,
    List<_Option> options,
    String? initialId,
  ) {
    String query = "";

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = options
                .where(
                  (o) => o.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    TextField(
                      autofocus: true,
                      onChanged: (v) => setState(() => query = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Ara...",
                      ),
                    ),

                    const SizedBox(height: 16),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 420),
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final o = filtered[i];

                          return ListTile(
                            title: Text(o.name),
                            trailing: o.id == initialId
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, o.id),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
}

// ---------------------------------------------------------------------------
// ⭐ GLASS FIELD
// ---------------------------------------------------------------------------
class _GlassField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.20), // 🔥 hafif cam efekti
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value ?? label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                    color: isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
class _Option {
  final String id;
  final String name;
  const _Option(this.id, this.name);
}
