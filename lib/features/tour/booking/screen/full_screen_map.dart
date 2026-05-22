import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/tour/booking/full_screen_map_viewmodel.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class FullMapView extends StatefulWidget {
  final double lat;
  final double lng;
  final String city;
  final String district;

  const FullMapView({
    super.key,
    required this.lat,
    required this.lng,
    required this.city,
    required this.district,
  });

  @override
  State<FullMapView> createState() => _FullMapViewState();
}

class _FullMapViewState extends State<FullMapView> {
  GoogleMapController? _mapController;
  late LatLng selectedPos;
  Set<Marker> markers = {};

  bool _locatingUser = false;

  @override
  void initState() {
    super.initState();
    selectedPos = LatLng(widget.lat, widget.lng);
    markers = {
      Marker(markerId: const MarkerId("initial"), position: selectedPos),
    };
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FullScreenMapViewModel>();

    return Scaffold(
      appBar: CommonAppBar(title: tr("select_location_title"), showBack: true),
      body: Stack(
        children: [
          // ---------------- GOOGLE MAP ----------------
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedPos,
              zoom: 16,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (ctrl) => _mapController = ctrl,
            onTap: (LatLng newPos) async {
              final result = await vm.validateTap(
                lat: newPos.latitude,
                lng: newPos.longitude,
                expectedCity: widget.city,
                expectedDistrict: widget.district,
              );

              if (result == null) return;

              if (!result.isValid) {
                // Return to valid bounds
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!mounted || _mapController == null) return;
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(widget.lat, widget.lng),
                      16,
                    ),
                  );
                });

                // Remove warning after a few seconds
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) vm.clearWarning();
                });
                return;
              }

              setState(() {
                selectedPos = newPos;
                markers = {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: newPos,
                  ),
                };
              });
            },
          ),

          // ---------------- WARNING (animasyon) ----------------
          Positioned(
            top: AppSpacing.l,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: vm.warningMessage != null ? 1 : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: vm.warningMessage != null
                    ? Offset.zero
                    : const Offset(0, -0.3),
                child: vm.warningMessage == null
                    ? const SizedBox.shrink()
                    : _warningBanner(vm.warningMessage!),
              ),
            ),
          ),

          // ---------------- LOCATION BUTTON ----------------
          Positioned(
            right: AppSpacing.l,
            bottom: vm.selectedAddress != null ? 160 : 90,
            child: Semantics(
              button: true,
              label: 'Go to my location',
              child: GestureDetector(
                onTap: _goToMyLocation,
                child: Container(
                  width: AppSpacing.xxxxxl,
                  height: AppSpacing.xxxxxl,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppElevation.shadowSm,
                  ),
                  child: _locatingUser
                      ? Padding(
                          padding: const EdgeInsets.all(AppSpacing.ml),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colors.secondary,
                          ),
                        )
                      : Icon(
                          Icons.my_location_rounded,
                          color: context.colors.secondary,
                          size: AppIconSize.xxl,
                          semanticLabel: 'My location',
                        ),
                ),
              ),
            ),
          ),

          // ---------------- BOTTOM INFO / BOTTOM BUTTON ----------------
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.xxl,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: vm.selectedAddress == null
                  ? _bottomInfoMessage() // Initial state -> info
                  : _confirmButton(vm), // After user selects -> button
            ),
          ),

          // ---------------- ADDRESS CARD ----------------
          if (vm.selectedAddress != null)
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: 90,
              child: _addressCard(vm.selectedAddress!),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // GO TO MY LOCATION
  // ----------------------------------------------------------
  Future<void> _goToMyLocation() async {
    if (_locatingUser) return;

    // Permission check
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied) {
      if (!mounted) return;
      openAppSettings();
      return;
    }

    if (!status.isGranted) return;

    setState(() => _locatingUser = true);

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      final myLatLng = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(myLatLng, 16),
      );
    } catch (e) {
      debugPrint('_FullMapViewState._goToMyLocation: $e');
      // Timeout or error -- silently ignore
    } finally {
      if (mounted) setState(() => _locatingUser = false);
    }
  }

  // ----------------------------------------------------------
  // BOTTOM INFO MESSAGE
  // ----------------------------------------------------------
  Widget _bottomInfoMessage() {
    return Container(
      key: const ValueKey("info"),
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.ml),
        boxShadow: AppElevation.shadowSm,
      ),
      child: Text(
        tr("map_tap_to_select"),
        textAlign: TextAlign.center,
        style: AppTextStyles.labelLarge,
      ),
    );
  }

  // ----------------------------------------------------------
  // USE LOCATION BUTTON
  // ----------------------------------------------------------
  Widget _confirmButton(FullScreenMapViewModel vm) {
    return PrimaryButton(
      onPressed: () {
        Navigator.pop(
          context,
          PlaceSelection(
            description: vm.selectedAddress!,
            lat: selectedPos.latitude,
            lng: selectedPos.longitude,
          ),
        );
      },
      text: tr("use_this_location"),
    );
  }

  // ----------------------------------------------------------
  // ADDRESS CARD
  // ----------------------------------------------------------
  Widget _addressCard(String text) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: _card(),
      child: Text(text, style: AppTextStyles.bodyMedium),
    );
  }

  // ----------------------------------------------------------
  // WARNING BANNER
  // ----------------------------------------------------------
  Widget _warningBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.error,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
      ),
    );
  }

  BoxDecoration _card() {
    return BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      boxShadow: AppElevation.shadowMd,
    );
  }
}
