import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Yeni paketi import ediyoruz

class TourVehicleListScreen extends StatelessWidget {
  const TourVehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Müsait Araçlar"), elevation: 0),
      body: vm.isVehiclesLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.vehicles == null
          ? const Center(child: Text("Veri bulunamadı."))
          : vm.vehicles!.isEmpty
          ? const Center(child: Text("Bu tarihte araç yok."))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF3F3F7), Color(0xFFE9EAF2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: vm.vehicles!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    final vehicle = vm.vehicles![index];
                    return _buildVehicleCard(context, vehicle);
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicle vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x13000000),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.read<TourSearchDetailViewModel>().setSelectedPrice(
            vehicle.price,
          );

          context.pushNamed('vehicleDetail', extra: vehicle.vehicleId);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Görsel ve fiyat badge'i -----
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  // FadeInImage yerine CachedNetworkImage kullanıldı
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: CachedNetworkImage(
                      imageUrl: vehicle.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 130,
                      // Yüklenirken gösterilecek placeholder
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      // Hata durumunda gösterilecek widget
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 9,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD4145A), Color(0xFFFBB03B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.11),
                          blurRadius: 8,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "${vehicle.price} ₺",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ----- Araç Bilgileri -----
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 2,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_car,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      vehicle.vehicleBrand,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 2,
              ),
              child: Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      vehicle.vehicleClass,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 2,
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      vehicle.vehicleType,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 2,
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_seat, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "${vehicle.seatCount} Koltuk",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // ----- Devam Et Butonu -----
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<TourSearchDetailViewModel>().setSelectedPrice(
                      vehicle.price,
                    );

                    context.pushNamed(
                      'vehicleDetail',
                      extra: vehicle.vehicleId,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text("Devam Et"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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
