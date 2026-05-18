import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/core/widgets/shake_widget.dart';
import 'package:tour_booking/features/tour/booking/widget/date_picker_sheet.dart';
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

  // ── City Picker ────────────────────────────────────────────
  Future<void> _pickCity(TransportViewModel vm) async {
    if (vm.cities.isEmpty) {
      await vm.fetchCities();
    }
    if (!mounted || vm.cities.isEmpty) return;

    final options =
        vm.cities.map((c) => PickerOption(c.id, c.name)).toList();

    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
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

  // ── Location Picker (dual mode) ────────────────────────────
  Future<void> _pickLocations(
      TransportViewModel vm, bool startAsPickup) async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<TransportLocationsResult>(
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
      _scrollToBottom();
    }
  }

  // ── Date Picker (bottom sheet) ─────────────────────────────
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
    if (picked != null) {
      vm.setSelectedDate(picked);
    }
  }

  // ── Time Picker (scroll wheel) ─────────────────────────────
  void _pickTime(TransportViewModel vm) {
    int selectedHour = 0;
    int selectedMinute = 0;

    // Parse existing selection
    if (vm.selectedTime != null) {
      final parts = vm.selectedTime!.split(':');
      selectedHour = int.tryParse(parts[0]) ?? 0;
      selectedMinute = int.tryParse(parts[1]) ?? 0;
    }

    final hourController =
        FixedExtentScrollController(initialItem: selectedHour);
    final minuteController =
        FixedExtentScrollController(initialItem: selectedMinute);

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TransportTimePicker(
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

  // ── Search Vehicles ────────────────────────────────────────
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

  // ── UI ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<TransportViewModel>(
          builder: (context, vm, _) {
            final hasRoute = vm.pickupLat != null && vm.dropoffLat != null;

            final dateText = vm.selectedDate != null
                ? DateFormat('dd MMM yyyy', 'tr_TR').format(vm.selectedDate!)
                : null;

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header (Seyahatlerim tarzı) ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding, 24, AppSpacing.screenPadding, 0,
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
                        const SizedBox(height: 6),
                        Text(
                          'transport_entry_subtitle'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Route Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Route Section ──
                        _sectionLabel(
                          SolarIconsOutline.routing,
                          tr("transport_route_section"),
                        ),
                        _sectionCard(
                          child: Column(
                            children: [
                              // City
                              ShakeWidget(
                                key: _cityShakeKey,
                                child: CompactPickerField(
                                  icon: SolarIconsOutline.buildings_3,
                                  label: tr("transport_select_city"),
                                  value: vm.selectedCityName,
                                  showError:
                                      _showErrors && vm.selectedCityId == null,
                                  onTap: () => _pickCity(vm),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.m),

                              // Connected pickup + dropoff
                              ConnectedLocationInputs(
                                pickupLabel: 'transport_select_pickup'.tr(),
                                pickupAddress: vm.pickupAddress,
                                dropoffLabel: 'transport_select_dropoff'.tr(),
                                dropoffAddress: vm.dropoffAddress,
                                onPickupTap: () => _pickLocations(vm, true),
                                onDropoffTap: () => _pickLocations(vm, false),
                                onSwap: (vm.pickupLat != null ||
                                        vm.dropoffLat != null)
                                    ? () => vm.swapLocations()
                                    : null,
                                showPickupError:
                                    _showErrors && vm.pickupLat == null,
                                showDropoffError:
                                    _showErrors && vm.dropoffLat == null,
                                pickupShakeKey: _pickupShakeKey,
                                dropoffShakeKey: _dropoffShakeKey,
                              ),

                              // Route map (conditional)
                              if (hasRoute) ...[
                                const SizedBox(height: AppSpacing.m),
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
                                    initialDistanceKm:
                                        vm.selectedRouteDistanceKm,
                                    onRouteSelected: (info) {
                                      vm.selectedRouteDistanceKm =
                                          info.distanceKm;
                                      vm.selectedRouteDurationMinutes =
                                          info.durationMinutes;
                                      _scrollToBottom();
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // ── Schedule Section ──
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

                        // ── Search Button ──
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

  // ── Helpers ──

  Widget _sectionLabel(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.accent),
          const SizedBox(width: AppSpacing.s),
          Text(
            text,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Scroll-wheel time picker (saat:dakika)
// ─────────────────────────────────────────────────────────────

class _TransportTimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final void Function(int hour, int minute) onConfirm;

  const _TransportTimePicker({
    required this.initialHour,
    required this.initialMinute,
    required this.hourController,
    required this.minuteController,
    required this.onConfirm,
  });

  @override
  State<_TransportTimePicker> createState() => _TransportTimePickerState();
}

class _TransportTimePickerState extends State<_TransportTimePicker> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
  }

  @override
  void dispose() {
    widget.hourController.dispose();
    widget.minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 42,
            height: 5,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(40),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    SolarIconsOutline.clockCircle,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  tr('time_select'),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Wheel pickers
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Hour wheel
                Expanded(
                  child: _buildWheel(
                    controller: widget.hourController,
                    itemCount: 24,
                    labelBuilder: (i) => i.toString().padLeft(2, '0'),
                    onChanged: (i) => setState(() => _hour = i),
                  ),
                ),

                // Separator
                Text(
                  ':',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                // Minute wheel
                Expanded(
                  child: _buildWheel(
                    controller: widget.minuteController,
                    itemCount: 60,
                    labelBuilder: (i) => i.toString().padLeft(2, '0'),
                    onChanged: (i) => setState(() => _minute = i),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Confirm button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onConfirm(_hour, _minute);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                child: Text(
                  tr('confirm'),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 48,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 1.5,
      perspective: 0.003,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isHour = controller == widget.hourController;
          final isSelected =
              isHour ? index == _hour : index == _minute;

          return Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: isSelected ? 22 : 16,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? AppColors.accent
                    : AppColors.textLight,
              ),
              child: Text(labelBuilder(index)),
            ),
          );
        },
      ),
    );
  }
}
