import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TourSearchDetailViewModel>().fetchVehicle(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();

    if (vm.isVehicleLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Araç Detayı')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.vehicle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Araç Detayı')),
        body: Center(child: Text(vm.errorMessage ?? 'Veri bulunamadı')),
      );
    }

    final v = vm.vehicle!;
    final price = vm.setVehiclePrice; // senin VM’deki fiyat getter

    return Scaffold(
      appBar: AppBar(title: Text(v.vehicleBrand)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana resim + fiyat rozet
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    v.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                if (price != null && price != 0)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$price ₺',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Küçük resimler (yatay scroll)
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: v.otherImages!.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      v.otherImages![i],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Araç bilgileri
            _info('Marka', v.vehicleBrand, Icons.directions_car_filled),
            _info('Tip', v.vehicleType, Icons.local_offer_rounded),
            _info('Sınıf', v.vehicleClass, Icons.category_rounded),
            _info('Koltuk', '${v.seatCount}', Icons.event_seat_rounded),
            if (v.modelYear != null)
              _info(
                'Model Yılı',
                '${v.modelYear}',
                Icons.calendar_today_rounded,
              ),
            if (v.legRoomSpace != null && v.legRoomSpace!.isNotEmpty)
              _info('Bacak Mesafesi', v.legRoomSpace!, Icons.swap_vert_rounded),
            if (v.seatType != null && v.seatType!.isNotEmpty)
              _info('Koltuk Tipi', v.seatType!, Icons.chair_alt_rounded),

            const SizedBox(height: 15),

            // Ek Özellikler
            if (v.vehicleFeatures != null && v.vehicleFeatures!.isNotEmpty) ...[
              const Text(
                'Ek Özellikler',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: v.vehicleFeatures!.map((feature) {
                  return Chip(
                    label: Text(feature),
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            // Devam butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/search-guide');
                },
                child: const Text('Devam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
