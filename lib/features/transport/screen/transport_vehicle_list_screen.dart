import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/transport/transport_vehicle_list_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_card.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_skeleton.dart';

class TransportVehicleListScreen extends StatelessWidget {
  final Map<String, dynamic> searchContext;

  const TransportVehicleListScreen({
    super.key,
    required this.searchContext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'transport_available_vehicles'.tr()),
      body: Consumer<TransportVehicleListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const TransportVehicleSkeleton();
          }

          if (vm.vehicles.isEmpty) {
            return EmptyState(
              icon: Icons.directions_car_outlined,
              title: 'transport_no_vehicles'.tr(),
              subtitle: 'transport_no_vehicles_subtitle'.tr(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.vehicles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, index) {
              final vehicle = vm.vehicles[index];
              return TransportVehicleCard(
                vehicle: vehicle,
                onTap: () {
                  context.push('/transport-vehicle-detail', extra: {
                    'vehicle': vehicle,
                    'pickupAddress': searchContext['pickupAddress'],
                    'pickupLat': searchContext['pickupLat'],
                    'pickupLng': searchContext['pickupLng'],
                    'dropoffAddress': searchContext['dropoffAddress'],
                    'dropoffLat': searchContext['dropoffLat'],
                    'dropoffLng': searchContext['dropoffLng'],
                    'date': searchContext['date'],
                    'time': searchContext['time'],
                    'clientDistanceKm': searchContext['clientDistanceKm'],
                    'clientDurationMinutes': searchContext['clientDurationMinutes'],
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
