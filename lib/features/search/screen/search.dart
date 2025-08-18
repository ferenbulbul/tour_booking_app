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
  DateTime? selectedDate;

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
    if (vm.selectedRegionId != null) {
      queryParams['regionId'] = vm.selectedRegionId!;
    }
    if (vm.selectedCityId != null) {
      queryParams['cityId'] = vm.selectedCityId!;
    }
    if (vm.selectedDistrictId != null) {
      queryParams['districtId'] = vm.selectedDistrictId!;
    }

    print("Navigasyon isteği gönderiliyor: $queryParams");
    context.pushNamed('searchResults', queryParameters: queryParams);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SearchViewmodel>().fetchRegions();
    });
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
              minWidth: 200.0,
              minHeight: 70.0,
              initialLabelIndex: _selectedToggleIndex,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['Kalkış Noktası', 'Tur Noktası'],
              icons: [Icons.import_contacts, Icons.add_ic_call],
              iconSize: 30.0,
              activeBgColors: [
                [Color(0xFF6A86D1), Color(0x420672FF)],
                [Colors.yellow, Colors.orange],
              ],
              animate: true,
              curve: Curves.bounceInOut,
              onToggle: (index) {
                setState(() => _selectedToggleIndex = index!);
              },
            ),
            const SizedBox(height: 24),
            vm.isRegionLoading
                ? LinearProgressIndicator()
                : DropdownButtonFormField<String>(
                    value: vm.selectedRegionId,
                    decoration: const InputDecoration(labelText: "Bölge Seçin"),
                    items: vm.regions
                        .map(
                          (region) => DropdownMenuItem(
                            value: region.id,
                            child: Text(region.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        vm.fetchCities(value);
                      }
                    },
                  ),

            const SizedBox(height: 16),

            vm.isCityLoading
                ? LinearProgressIndicator()
                : DropdownButtonFormField<String>(
                    value: vm.selectedCityId ?? '',
                    decoration: const InputDecoration(labelText: "İl Seçin"),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text("Tüm İller"),
                      ),
                      ...vm.cities.map(
                        (city) => DropdownMenuItem(
                          value: city.id,
                          child: Text(city.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        vm.selectedCityId = null;
                        vm.selectedDistrictId = null;
                        vm.districts = [];
                        vm.notifyListeners();
                      } else {
                        vm.fetchDistricts(value);
                      }
                    },
                  ),

            const SizedBox(height: 16),

            /// ILÇE DROPDOWN
            vm.isDistrictLoading
                ? const Center(child: LinearProgressIndicator())
                : DropdownButtonFormField<String>(
                    value: vm.selectedDistrictId ?? '',
                    decoration: const InputDecoration(labelText: "İlçe Seçin"),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text("Tüm İlçeler"),
                      ),
                      ...vm.districts.map(
                        (district) => DropdownMenuItem(
                          value: district.id,
                          child: Text(district.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        vm.selectDistrict('');
                      } else {
                        vm.selectDistrict(value);
                      }
                    },
                  ),

            const SizedBox(height: 24),

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
}
