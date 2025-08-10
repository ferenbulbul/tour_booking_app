import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/screen/tour_vehicle_list_screen.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';

class TourSearchDetailScreen extends StatefulWidget {
  final String tourPointId;

  const TourSearchDetailScreen({super.key, required this.tourPointId});

  @override
  State<TourSearchDetailScreen> createState() => _TourSearchDetailScreenState();
}

class _TourSearchDetailScreenState extends State<TourSearchDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TourSearchDetailViewModel>(
        context,
        listen: false,
      ).fetchTourPointDetail(widget.tourPointId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TourSearchDetailViewModel>(context);
    final detail = viewModel.detail;

    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (detail == null) {
      return const Scaffold(body: Center(child: Text("Detay bulunamadı.")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(detail.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana görsel
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                detail.mainImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // Diğer görseller
            _buildImageGallery(detail.otherImages),
            const SizedBox(height: 20),

            // Açıklama
            Text(detail.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // Şehir dropdown
            _buildCityDropdown(viewModel),
            const SizedBox(height: 12),

            // İlçe dropdown
            _buildDistrictDropdown(viewModel),
            const SizedBox(height: 20),

            // Tarih seçici
            const Text(
              "Tarih Seçin",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDatePicker(viewModel),
            const SizedBox(height: 20),

            // Buton
            ElevatedButton(
              onPressed: () async {
                final vm = context.read<TourSearchDetailViewModel>();

                if (vm.selectedCityId == null ||
                    vm.selectedDistrictId == null ||
                    vm.selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun"),
                    ),
                  );
                  return;
                }

                await vm.fetchVehicles();

                if (vm.vehicles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Bu tarihte müsait araç bulunamadı"),
                    ),
                  );
                } else {
                  context.pushNamed(
                    'vehicleList',
                    queryParameters: {
                      'cityId': vm.selectedCityId!,
                      'districtId': vm.selectedDistrictId!,
                      'tourPointId': widget.tourPointId,
                      'date': vm.selectedDate!.toIso8601String(),
                    },
                  );
                }
              },
              child: const Text("Araçları Gör"),
            ),
          ],
        ),
      ),
    );
  }

  // 🔽 Diğer görseller yatay scroll
  Widget _buildImageGallery(List<String> otherImages) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: otherImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          controller: PageController(initialPage: index),
                          itemCount: otherImages.length,
                          itemBuilder: (context, pageIndex) {
                            return Image.network(
                              otherImages[pageIndex],
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                otherImages[index],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔽 Şehir dropdown
  Widget _buildCityDropdown(TourSearchDetailViewModel vm) {
    return DropdownButtonFormField<String>(
      value: vm.selectedCityId,
      decoration: const InputDecoration(labelText: "Şehir Seçin"),
      items: vm.detail?.cities.map((city) {
        return DropdownMenuItem(value: city.id, child: Text(city.name));
      }).toList(),
      onChanged: vm.setSelectedCity,
    );
  }

  // 🔽 İlçe dropdown
  Widget _buildDistrictDropdown(TourSearchDetailViewModel vm) {
    final filteredDistricts =
        vm.detail?.districts
            .where((d) => d.cityId == vm.selectedCityId)
            .toList() ??
        [];

    return DropdownButtonFormField<String>(
      value: vm.selectedDistrictId,
      decoration: const InputDecoration(labelText: "İlçe Seçin"),
      items: filteredDistricts.map((district) {
        return DropdownMenuItem(value: district.id, child: Text(district.name));
      }).toList(),
      onChanged: vm.setSelectedDistrict,
    );
  }

  // 🔽 Tarih seçici
  Widget _buildDatePicker(TourSearchDetailViewModel vm) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          vm.setSelectedDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          vm.selectedDate != null
              ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
              : "Tarih Seçiniz",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
