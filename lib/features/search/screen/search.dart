import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tour_booking/features/search/search_viewmodel.dart';

class TourSearchScreen extends StatefulWidget {
  const TourSearchScreen({super.key});

  @override
  State<TourSearchScreen> createState() => _TourSearchScreenState();
}

class _TourSearchScreenState extends State<TourSearchScreen> {
  int _selectedToggleIndex = 0;

  void _submitSearch(SearchViewmodel vm) {
    if (vm.selectedRegionId == null || vm.selectedRegionId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen önce bir bölge seçin."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final Map<String, String> queryParams = {
      'type': _selectedToggleIndex.toString(),
    };
    if (vm.selectedRegionId != null)
      queryParams['regionId'] = vm.selectedRegionId!;
    if (vm.selectedCityId != null) queryParams['cityId'] = vm.selectedCityId!;
    if (vm.selectedDistrictId != null && vm.selectedDistrictId!.isNotEmpty) {
      queryParams['districtId'] = vm.selectedDistrictId!;
    }

    context.pushNamed('searchResults', queryParameters: queryParams);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SearchViewmodel>().fetchRegions());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Detaylı Arama")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleSwitch(
              animationDuration: 200,
              minWidth: 200.0,
              minHeight: 70.0,
              initialLabelIndex: _selectedToggleIndex,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: const ['Kalkış Noktası', 'Tur Noktası'],
              icons: const [Icons.my_location, Icons.location_on_outlined],
              iconSize: 30.0,
              activeBgColors: const [
                [Color.fromARGB(255, 50, 97, 224), Color(0x420672FF)],
                [Color.fromARGB(255, 50, 97, 224), Color(0x420672FF)],
              ],
              animate: true,
              curve: Curves.bounceInOut,
              onToggle: (index) =>
                  setState(() => _selectedToggleIndex = index ?? 0),
            ),

            const SizedBox(height: 24),

            // --- Bölge
            if (vm.isRegionLoading)
              const LinearProgressIndicator()
            else
              _SelectField(
                label: "Bölge Seçin",
                valueLabel: _nameById(vm.regions, vm.selectedRegionId),
                icon: Icons.map_outlined,
                onTap: () async {
                  final id = await _openPicker(
                    title: "Bölge Seçin",
                    initialId: vm.selectedRegionId,
                    options: vm.regions
                        .map((r) => _Option(r.id, r.name))
                        .toList(),
                  );
                  if (id != null) {
                    // fetchCities genelde selectedRegionId'yi de set eder
                    vm.fetchCities(id);
                  }
                },
              ),

            const SizedBox(height: 16),

            // --- İl
            if (vm.isCityLoading)
              const LinearProgressIndicator()
            else
              _SelectField(
                label: "İl Seçin",
                valueLabel: vm.selectedCityId == null
                    ? "Tüm İller"
                    : _nameById(vm.cities, vm.selectedCityId),
                icon: Icons.location_city_outlined,
                onTap: () async {
                  // “Tüm İller” seçeneğini liste başına ekle
                  final options = [
                    const _Option('', 'Tüm İller'),
                    ...vm.cities.map((c) => _Option(c.id, c.name)),
                  ];
                  final id = await _openPicker(
                    title: "İl Seçin",
                    initialId: vm.selectedCityId ?? '',
                    options: options,
                  );
                  if (id != null) {
                    if (id.isEmpty) {
                      vm.selectedCityId = null;
                      vm.selectedDistrictId = null;
                      vm.districts = [];
                      vm.notifyListeners();
                    } else {
                      vm.fetchDistricts(
                        id,
                      ); // genelde selectedCityId'yi de set eder
                    }
                  }
                },
              ),

            const SizedBox(height: 16),

            // --- İlçe
            if (vm.isDistrictLoading)
              const LinearProgressIndicator()
            else
              _SelectField(
                label: "İlçe Seçin",
                valueLabel:
                    (vm.selectedDistrictId == null ||
                        vm.selectedDistrictId!.isEmpty)
                    ? "Tüm İlçeler"
                    : _nameById(vm.districts, vm.selectedDistrictId),
                icon: Icons.location_on_outlined,
                onTap: () async {
                  final options = [
                    const _Option('', 'Tüm İlçeler'),
                    ...vm.districts.map((d) => _Option(d.id, d.name)),
                  ];
                  final id = await _openPicker(
                    title: "İlçe Seçin",
                    initialId: vm.selectedDistrictId ?? '',
                    options: options,
                  );
                  if (id != null) {
                    if (id.isEmpty) {
                      vm.selectDistrict('');
                    } else {
                      vm.selectDistrict(id);
                    }
                  }
                },
              ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitSearch(vm),
                child: const Text("Ara"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------- Helpers (bottom sheet + lookup) --------

  Future<String?> _openPicker({
    required String title,
    required List<_Option> options,
    String? initialId,
  }) async {
    String query = '';
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                final filtered = options
                    .where(
                      (o) => o.name.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          tooltip: 'Kapat',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      autofocus: true,
                      onChanged: (v) => setState(() => query = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Ara...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 420),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final o = filtered[i];
                          final selected = o.id == (initialId ?? '');
                          return ListTile(
                            title: Text(o.name),
                            trailing: selected
                                ? const Icon(Icons.check, size: 20)
                                : null,
                            onTap: () => Navigator.pop(context, o.id),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  String? _nameById(List<dynamic> items, String? id) {
    if (id == null) return null;
    for (final it in items) {
      final itemId = (it as dynamic).id as String;
      if (itemId == id) return (it as dynamic).name as String;
    }
    return null;
  }
}

// ---- Small UI primitives ----
class _Option {
  final String id;
  final String name;
  const _Option(this.id, this.name);
}

class _SelectField extends StatelessWidget {
  final String label;
  final String? valueLabel;
  final VoidCallback onTap;
  final IconData? icon;
  const _SelectField({
    required this.label,
    required this.valueLabel,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          valueLabel ?? 'Seçiniz',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
