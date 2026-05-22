import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/core/widgets/shake_widget.dart';
import 'package:tour_booking/features/tour/booking/widget/date_picker_sheet.dart';
import 'package:tour_booking/features/transport/screen/transport_place_picker_screen.dart';
import 'package:tour_booking/features/transport/transport_place_picker_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_city_list.dart';
import 'package:tour_booking/features/transport/widget/transport_location_summary.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final _scrollController = ScrollController();
  bool _showErrors = false;
  final _cityShakeKey = GlobalKey<ShakeWidgetState>();
  final _pickupShakeKey = GlobalKey<ShakeWidgetState>();
  final _dropoffShakeKey = GlobalKey<ShakeWidgetState>();
  final _dateShakeKey = GlobalKey<ShakeWidgetState>();
  final _timeShakeKey = GlobalKey<ShakeWidgetState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportViewModel>().init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent > 0) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _shakeEmptyFields(TransportViewModel vm) {
    if (vm.selectedCityId == null) _cityShakeKey.currentState?.shake();
    if (vm.pickupLat == null) _pickupShakeKey.currentState?.shake();
    if (vm.dropoffLat == null) _dropoffShakeKey.currentState?.shake();
    if (vm.selectedDate == null) _dateShakeKey.currentState?.shake();
    if (vm.selectedTime == null) _timeShakeKey.currentState?.shake();
  }

  Future<void> _pickCity(TransportViewModel vm) async {
    if (vm.cities.isEmpty) await vm.fetchCities();
    if (!mounted || vm.cities.isEmpty) return;
    final options = vm.cities.map((c) => PickerOption(c.id, c.name)).toList();
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PickerSheet(
        title: tr('transport_select_pickup_city'),
        options: options,
        initialId: vm.selectedCityId,
      ),
    );

    if (selected != null) {
      final city = vm.cities.firstWhere((c) => c.id == selected);
      vm.setSelectedCity(city.id, city.name);
    }
  }

  Future<void> _pickLocations(TransportViewModel vm, bool startAsPickup) async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<TransportLocationsResult>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => TransportPlacePickerViewModel(
            pickupLat: vm.pickupLat,
            pickupLng: vm.pickupLng,
            pickupAddress: vm.pickupAddress,
            dropoffLat: vm.dropoffLat,
            dropoffLng: vm.dropoffLng,
            dropoffAddress: vm.dropoffAddress,
            initialModePickup: startAsPickup,
            cityName: vm.selectedCityName,
          ),
          child: const TransportPlacePickerScreen(),
        ),
      ),
    );
    if (result != null) {
      vm.setLocationsFromPicker(result);
      _scrollToBottom();
    }
  }

  Future<void> _pickDate(TransportViewModel vm) async {
    final now = DateTime.now();
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DatePickerSheet(
        initialDate: vm.selectedDate ?? now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 90)),
      ),
    );
    if (picked != null) vm.setSelectedDate(picked);
  }

  void _pickTime(TransportViewModel vm) {
    int selectedHour = 0;
    int selectedMinute = 0;
    if (vm.selectedTime != null) {
      final parts = vm.selectedTime!.split(':');
      selectedHour = int.tryParse(parts[0]) ?? 0;
      selectedMinute = int.tryParse(parts[1]) ?? 0;
    }
    final hourController = FixedExtentScrollController(initialItem: selectedHour);
    final minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransportTimePicker(
        initialHour: selectedHour,
        initialMinute: selectedMinute,
        hourController: hourController,
        minuteController: minuteController,
        onConfirm: (hour, minute) {
          final time =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          vm.setSelectedTime(time);
        },
      ),
    );
  }

  void _searchVehicles(TransportViewModel vm) {
    if (!vm.canSearch) {
      setState(() => _showErrors = true);
      _shakeEmptyFields(vm);
      UIHelper.showWarning(context, tr("fill_all_fields_warning"));
      return;
    }
    final request = TransportSearchVehiclesRequest(
      cityId: vm.selectedCityId!,
      date: vm.selectedDate!,
      startTime: vm.selectedTime!,
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Consumer<TransportViewModel>(
          builder: (context, vm, _) {
            final dateText = vm.selectedDate != null
                ? DateFormat('dd MMM yyyy', 'tr_TR').format(vm.selectedDate!)
                : null;

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding, AppSpacing.xxl, AppSpacing.screenPadding, 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'transport_title'.tr(),
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'transport_entry_subtitle'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TransportLocationSummary(
                          vm: vm,
                          showErrors: _showErrors,
                          cityShakeKey: _cityShakeKey,
                          pickupShakeKey: _pickupShakeKey,
                          dropoffShakeKey: _dropoffShakeKey,
                          onPickCity: () => _pickCity(vm),
                          onPickupTap: () => _pickLocations(vm, true),
                          onDropoffTap: () => _pickLocations(vm, false),
                          onRouteSelected: (info) {
                            vm.selectedRouteDistanceKm = info.distanceKm;
                            vm.selectedRouteDurationMinutes =
                                info.durationMinutes;
                            _scrollToBottom();
                          },
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        _sectionLabel(
                          SolarIconsOutline.calendarDate,
                          tr("transport_schedule_section"),
                        ),
                        _sectionCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: ShakeWidget(
                                  key: _dateShakeKey,
                                  child: CompactPickerField(
                                    icon: SolarIconsOutline.calendarDate,
                                    label: tr("transport_select_date"),
                                    value: dateText,
                                    showError: _showErrors &&
                                        vm.selectedDate == null,
                                    onTap: () => _pickDate(vm),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: ShakeWidget(
                                  key: _timeShakeKey,
                                  child: CompactPickerField(
                                    icon: SolarIconsOutline.clockCircle,
                                    label: tr("transport_select_time"),
                                    value: vm.selectedTime,
                                    showError: _showErrors &&
                                        vm.selectedTime == null,
                                    onTap: () => _pickTime(vm),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        PrimaryButton(
                          text: 'transport_search_vehicles'.tr(),
                          icon: SolarIconsOutline.magnifier,
                          onPressed: () => _searchVehicles(vm),
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.xl - 2, color: context.colors.secondary),
          const SizedBox(width: AppSpacing.s),
          Text(
            text,
            style: AppTextStyles.titleSmall.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppElevation.shadowSm,
      ),
      child: child,
    );
  }
}
