import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/vehicle_skelaton.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

class TourVehicleListScreen extends StatelessWidget {
  const TourVehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Müsait Araçlar", style: TextStyle())),
      body: vm.isVehiclesLoading
          ? const Center(child: VehicleCardSkeleton())
          : vm.vehicles == null || vm.vehicles!.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: vm.vehicles!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return VehicleCard(vehicle: vm.vehicles![index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.no_crash_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Bu kriterlere uygun araç bulunamadı",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final vm = context.read<TourSearchDetailViewModel>();

        vm.setSelectedPrice(vehicle.price);

        final request = VehicleDetailRequest(
          vehicleId: vehicle.vehicleId,
          tourRouteId: vehicle.tourRouteId, // vehicle içinde varsa direkt böyle
          // gerekiyorsa diğer parametreleri de modele ekleyebilirsin
        );

        context.pushNamed('vehicleDetail', extra: request);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE + PRICE BADGE ----------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: vehicle.image,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade200),
                  ),
                ),

                // Soft gradient (çok hafif, premium)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.15),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Fiyat — sade, primary color
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6CF7), // primary color
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A6CF7).withOpacity(.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "${vehicle.price} ₺",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ---------------- BRAND NAME ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                vehicle.vehicleBrand,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600, // daha ince
                  color: Color(0xFF1A1D29),
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------------- FEATURES ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _featureChip(
                    icon: Icons.event_seat,
                    label: "${vehicle.seatCount} Koltuk",
                  ),
                  const SizedBox(width: 10),
                  _featureChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: vehicle.vehicleType,
                  ),
                  const SizedBox(width: 10),
                  _featureChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: vehicle.vehicleClass,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ---------------- REUSABLE CHIP ----------------
  Widget _featureChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF4A6CF7)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
