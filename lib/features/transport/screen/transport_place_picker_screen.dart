import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/features/transport/screen/transport_search_sheet.dart';
import 'package:tour_booking/features/transport/transport_place_picker_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_search_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/place_picker_map_view.dart';
import 'package:tour_booking/features/transport/widget/route_options_panel.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportPlacePickerScreen extends StatefulWidget {
  const TransportPlacePickerScreen({super.key});

  @override
  State<TransportPlacePickerScreen> createState() =>
      _TransportPlacePickerScreenState();
}

class _TransportPlacePickerScreenState
    extends State<TransportPlacePickerScreen> {
  GoogleMapController? _mapController;
  late final TransportPlacePickerViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<TransportPlacePickerViewModel>();

    // Wire up UI callbacks
    _vm.onCameraAnimateRequest = _animateCamera;
    _vm.onFitBoundsRequest = _fitBounds;
    _vm.onCityValidationError = _showCityValidationError;

    if (_vm.bothSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _vm.fetchRoutes());
    }
  }

  @override
  void dispose() {
    _vm.onCameraAnimateRequest = null;
    _vm.onFitBoundsRequest = null;
    _vm.onCityValidationError = null;
    super.dispose();
  }

  // ---------------------------------------------------------------
  // CAMERA (UI concern -- needs GoogleMapController)
  // ---------------------------------------------------------------
  void _animateCamera(LatLng pos, double zoom) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, zoom));
  }

  void _fitBounds() {
    final vm = context.read<TransportPlacePickerViewModel>();
    if (!vm.bothSet || _mapController == null) return;
    final south = min(vm.pickupPos!.latitude, vm.dropoffPos!.latitude);
    final north = max(vm.pickupPos!.latitude, vm.dropoffPos!.latitude);
    final west = min(vm.pickupPos!.longitude, vm.dropoffPos!.longitude);
    final east = max(vm.pickupPos!.longitude, vm.dropoffPos!.longitude);

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(south, west),
        northeast: LatLng(north, east),
      ),
      80,
    ));
  }

  // ---------------------------------------------------------------
  // CITY VALIDATION ERROR (UI concern -- needs BuildContext)
  // ---------------------------------------------------------------
  void _showCityValidationError(String message) {
    if (mounted) {
      UIHelper.showError(context, message);
    }
  }

  // ---------------------------------------------------------------
  // SEARCH SHEET (UI concern -- uses showModalBottomSheet)
  // ---------------------------------------------------------------
  Future<void> _openSearchSheet(bool forPickup) async {
    final vm = context.read<TransportPlacePickerViewModel>();
    vm.isPickupMode = forPickup;

    final result = await showModalBottomSheet<PlaceResult>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => TransportSearchViewModel(),
        child: TransportSearchSheet(
          apiKey: vm.apiKey,
          cityBias: forPickup ? vm.cityName : null,
          cityCenter: forPickup ? vm.cityCenter : null,
          cityName: forPickup ? vm.cityName : null,
          hintText: forPickup
              ? tr('transport_search_pickup')
              : tr('transport_search_dropoff'),
          iconColor: forPickup ? context.ext.success : context.colors.error,
        ),
      ),
    );

    if (result != null && mounted) {
      if (forPickup) {
        vm.setPickup(LatLng(result.lat, result.lng), result.address);
      } else {
        vm.setDropoff(LatLng(result.lat, result.lng), result.address);
      }
    }
  }

  // ---------------------------------------------------------------
  // CONFIRM (UI concern -- uses Navigator.pop)
  // ---------------------------------------------------------------
  void _confirm() {
    final vm = context.read<TransportPlacePickerViewModel>();
    Navigator.pop(context, vm.confirmResult);
  }

  // ---------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransportPlacePickerViewModel>();
    final bottomH = vm.routes.length > 1 ? 310.0 : 240.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // -- MAP + TOP BAR (extracted) --
          PlacePickerMapView(
            vm: vm,
            mapController: _mapController,
            onMapCreated: (c) {
              _mapController = c;
              vm.geocodeCity();
              if (vm.bothSet && vm.routes.isEmpty) {
                Future.delayed(
                    const Duration(milliseconds: 500), _fitBounds);
              }
            },
            bottomPadding: bottomH,
            onBack: () => Navigator.pop(context),
            modeToggle: _buildModeToggle(vm),
          ),

          // -- BOTTOM CARD (extracted) --
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RouteOptionsPanel(
              vm: vm,
              onPickupTap: () => _openSearchSheet(true),
              onDropoffTap: () => _openSearchSheet(false),
              onConfirm: vm.bothSet ? _confirm : null,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // MODE TOGGLE
  // ---------------------------------------------------------------
  Widget _buildModeToggle(TransportPlacePickerViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          _modeTab(tr('transport_pickup'), context.ext.success, vm.isPickupMode,
              () => vm.isPickupMode = true),
          _modeTab(tr('transport_dropoff'), context.colors.error, !vm.isPickupMode,
              () => vm.isPickupMode = false),
        ],
      ),
    );
  }

  Widget _modeTab(
      String label, Color color, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
            decoration: BoxDecoration(
              color: isActive ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle,
                    size: AppSpacing.ms, color: isActive ? Colors.white : color),
                const SizedBox(width: AppSpacing.sm),
                Text(label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color:
                          isActive ? Colors.white : context.colors.onSurface,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
