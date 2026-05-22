import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/transport/transport_place_picker_viewmodel.dart';

/// The Google Map portion of the place picker, including polylines,
/// a loading indicator for routes, and the top bar with back + mode toggle.
class PlacePickerMapView extends StatelessWidget {
  final TransportPlacePickerViewModel vm;
  final GoogleMapController? mapController;
  final void Function(GoogleMapController controller) onMapCreated;
  final double bottomPadding;
  final VoidCallback onBack;
  final Widget modeToggle;

  const PlacePickerMapView({
    super.key,
    required this.vm,
    required this.mapController,
    required this.onMapCreated,
    required this.bottomPadding,
    required this.onBack,
    required this.modeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // -- MAP --
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: vm.initialCameraPos,
            zoom: vm.initialZoom,
          ),
          markers: vm.buildMarkers(
            onPickupDragEnd: (pos) =>
                vm.setPickup(pos, null, reverseGeocode: true),
            onDropoffDragEnd: (pos) =>
                vm.setDropoff(pos, null, reverseGeocode: true),
          ),
          polylines: _buildPolylines(context, vm),
          onMapCreated: onMapCreated,
          onTap: vm.onMapTap,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          padding: EdgeInsets.only(top: AppSpacing.huge, bottom: bottomPadding),
        ),

        // -- ROUTES LOADING --
        if (vm.routesLoading)
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l, vertical: AppSpacing.s),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                        width: AppIconSize.m,
                        height: AppIconSize.m,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: AppSpacing.s),
                    Text(tr('transport_calculating_route'),
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ),

        // -- TOP: Back + Mode toggle --
        SafeArea(
          bottom: false,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
            child: Row(
              children: [
                _circleButton(context, Icons.arrow_back_ios_new, onBack),
                const SizedBox(width: AppSpacing.m),
                Expanded(child: modeToggle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Set<Polyline> _buildPolylines(
      BuildContext context, TransportPlacePickerViewModel vm) {
    if (vm.routes.isEmpty) return {};
    final polylines = <Polyline>{};

    for (int i = 0; i < vm.routes.length; i++) {
      if (i == vm.selectedRouteIndex) continue;
      polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: vm.routes[i].points,
        color: context.ext.textLight,
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        consumeTapEvents: true,
        onTap: () => vm.selectRoute(i),
      ));
    }

    polylines.add(Polyline(
      polylineId: PolylineId('route_selected_${vm.selectedRouteIndex}'),
      points: vm.routes[vm.selectedRouteIndex].points,
      color: context.colors.primary,
      width: 5,
    ));

    return polylines;
  }

  Widget _circleButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: 'Map action',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSpacing.xxxxl,
          height: AppSpacing.xxxxl,
          decoration: BoxDecoration(
            color: context.colors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8),
            ],
          ),
          child: Icon(icon, size: AppIconSize.l),
        ),
      ),
    );
  }
}
