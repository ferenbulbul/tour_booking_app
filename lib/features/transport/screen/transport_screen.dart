import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/transport/screen/transport_place_picker_screen.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_location_input.dart';
import 'package:tour_booking/features/transport/widget/transport_route_map.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportViewModel>().init();
    });
  }

  // ---------------------------------------------------------------
  // City Picker
  // ---------------------------------------------------------------
  Future<void> _pickCity(TransportViewModel vm) async {
    final options =
        vm.cities.map((c) => PickerOption(c.id, c.name)).toList();

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PickerSheet(
        title: 'Kalkış şehri seçin',
        options: options,
        initialId: vm.selectedCityId,
      ),
    );

    if (selected != null) {
      final city = vm.cities.firstWhere((c) => c.id == selected);
      vm.setSelectedCity(city.id, city.name);
    }
  }

  // ---------------------------------------------------------------
  // Location Picker (dual mode)
  // ---------------------------------------------------------------
  Future<void> _pickLocations(
      TransportViewModel vm, bool startAsPickup) async {
    final result = await Navigator.push<TransportLocationsResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TransportPlacePickerScreen(
          pickupLat: vm.pickupLat,
          pickupLng: vm.pickupLng,
          pickupAddress: vm.pickupAddress,
          dropoffLat: vm.dropoffLat,
          dropoffLng: vm.dropoffLng,
          dropoffAddress: vm.dropoffAddress,
          initialModePickup: startAsPickup,
          cityName: vm.selectedCityName,
        ),
      ),
    );

    if (result != null) {
      vm.setLocationsFromPicker(result);
    }
  }

  // ---------------------------------------------------------------
  // Date Picker
  // ---------------------------------------------------------------
  Future<void> _pickDate(TransportViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      locale: context.locale,
    );
    if (picked != null) {
      vm.setSelectedDate(picked);
    }
  }

  // ---------------------------------------------------------------
  // Time Picker
  // ---------------------------------------------------------------
  Future<void> _pickTime(TransportViewModel vm) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      vm.setSelectedTime('$h:$m');
    }
  }

  // ---------------------------------------------------------------
  // Search Vehicles
  // ---------------------------------------------------------------
  void _searchVehicles(TransportViewModel vm) {
    if (!vm.canSearch) return;

    final request = TransportSearchVehiclesRequest(
      cityId: vm.selectedCityId!,
      date: vm.selectedDate!,
      startTime: vm.selectedTime!,
    );

    debugPrint('🟢 SEARCH: clientDistanceKm=${vm.selectedRouteDistanceKm}, clientDurationMinutes=${vm.selectedRouteDurationMinutes}');
    context.push('/transport-vehicles', extra: {
      'request': request.toJson(),
      'pickupAddress': vm.pickupAddress,
      'pickupLat': vm.pickupLat,
      'pickupLng': vm.pickupLng,
      'dropoffAddress': vm.dropoffAddress,
      'dropoffLat': vm.dropoffLat,
      'dropoffLng': vm.dropoffLng,
      'date': vm.selectedDate!.toIso8601String(),
      'time': vm.selectedTime,
      'clientDistanceKm': vm.selectedRouteDistanceKm,
      'clientDurationMinutes': vm.selectedRouteDurationMinutes,
    });
  }

  // ---------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'transport_title'.tr(), showBack: true),
      body: Consumer<TransportViewModel>(
        builder: (context, vm, _) {
          final hasRoute = vm.pickupLat != null && vm.dropoffLat != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- City ---
                Text('Kalkış şehri seçin', style: _labelStyle()),
                const SizedBox(height: 8),
                PickerField(
                  label: 'Kalkış şehri seçin',
                  value: vm.selectedCityName,
                  icon: Icons.location_city,
                  onTap: () => _pickCity(vm),
                ),

                const SizedBox(height: AppSpacing.xl),

                // --- Pickup ---
                Text('transport_pickup'.tr(), style: _labelStyle()),
                const SizedBox(height: 8),
                TransportLocationInput(
                  label: 'transport_select_pickup'.tr(),
                  address: vm.pickupAddress,
                  dotColor: Colors.green,
                  onTap: () => _pickLocations(vm, true),
                ),

                const SizedBox(height: AppSpacing.l),

                // --- Dropoff ---
                Text('transport_dropoff'.tr(), style: _labelStyle()),
                const SizedBox(height: 8),
                TransportLocationInput(
                  label: 'transport_select_dropoff'.tr(),
                  address: vm.dropoffAddress,
                  dotColor: Colors.red,
                  onTap: () => _pickLocations(vm, false),
                ),

                // --- Mini Route Map (when both set) ---
                if (hasRoute) ...[
                  const SizedBox(height: AppSpacing.l),
                  GestureDetector(
                    onTap: () => _pickLocations(vm, true),
                    child: TransportRouteMap(
                      key: ValueKey(
                          '${vm.pickupLat}_${vm.pickupLng}_${vm.dropoffLat}_${vm.dropoffLng}'),
                      pickupLat: vm.pickupLat!,
                      pickupLng: vm.pickupLng!,
                      dropoffLat: vm.dropoffLat!,
                      dropoffLng: vm.dropoffLng!,
                      height: 160,
                      initialDistanceKm: vm.selectedRouteDistanceKm,
                      onRouteSelected: (info) {
                        vm.selectedRouteDistanceKm = info.distanceKm;
                        vm.selectedRouteDurationMinutes = info.durationMinutes;
                        debugPrint('🔵 ROUTE SELECTED: ${info.distanceKm} km / ${info.durationMinutes} min');
                      },
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.l),

                // --- Date & Time (side by side) ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('transport_select_date'.tr(),
                              style: _labelStyle()),
                          const SizedBox(height: 8),
                          PickerField(
                            label: 'transport_select_date'.tr(),
                            value: vm.selectedDate != null
                                ? DateFormat('dd MMM yyyy', 'tr_TR')
                                    .format(vm.selectedDate!)
                                : null,
                            icon: Icons.calendar_today,
                            onTap: () => _pickDate(vm),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('transport_select_time'.tr(),
                              style: _labelStyle()),
                          const SizedBox(height: 8),
                          PickerField(
                            label: 'transport_select_time'.tr(),
                            value: vm.selectedTime,
                            icon: Icons.access_time,
                            onTap: () => _pickTime(vm),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // --- Search Button ---
                PrimaryButton(
                  text: 'transport_search_vehicles'.tr(),
                  icon: Icons.search,
                  onPressed:
                      vm.canSearch ? () => _searchVehicles(vm) : null,
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  TextStyle _labelStyle() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );
}
