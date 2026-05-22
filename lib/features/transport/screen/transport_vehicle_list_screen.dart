import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/transport/transport_vehicle_list_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_card.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_detail_sheet.dart';
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
              icon: SolarIconsOutline.routing,
              title: 'transport_no_vehicles'.tr(),
              subtitle: 'transport_no_vehicles_subtitle'.tr(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: vm.vehicles.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.ml),
            itemBuilder: (_, index) {
              final vehicle = vm.vehicles[index];
              return TransportVehicleCard(
                vehicle: vehicle,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => TransportVehicleDetailSheet(
                      vehicle: vehicle,
                      searchContext: searchContext,
                      navigatorContext: context,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
