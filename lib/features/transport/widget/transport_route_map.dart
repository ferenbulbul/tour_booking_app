import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/transport/transport_route_map_viewmodel.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

/// Route info passed to parent via [onRouteSelected].
class RouteInfo {
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;
  final String summary;

  const RouteInfo({
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
    required this.summary,
  });
}

class TransportRouteMap extends StatefulWidget {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double height;
  final bool fetchRoute;
  final double? initialDistanceKm;
  final ValueChanged<RouteInfo>? onRouteSelected;
  final VoidCallback? onRouteFetchFailed;

  const TransportRouteMap({
    super.key,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.height = 220,
    this.fetchRoute = true,
    this.initialDistanceKm,
    this.onRouteSelected,
    this.onRouteFetchFailed,
  });

  @override
  State<TransportRouteMap> createState() => _TransportRouteMapState();
}

class _TransportRouteMapState extends State<TransportRouteMap> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  LatLng get _pickup => LatLng(widget.pickupLat, widget.pickupLng);
  LatLng get _dropoff => LatLng(widget.dropoffLat, widget.dropoffLng);

  @override
  void initState() {
    super.initState();
    _setupMarkers();
    if (widget.fetchRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchRoutes();
      });
    }
  }

  void _setupMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoff,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Dropoff'),
      ),
    ]);
  }

  Future<void> _fetchRoutes() async {
    final vm = context.read<TransportRouteMapViewModel>();
    await vm.fetchRoutes(
      pickup: _pickup,
      dropoff: _dropoff,
      initialDistanceKm: widget.initialDistanceKm,
    );

    if (!mounted) return;

    if (vm.fetchFailed) {
      widget.onRouteFetchFailed?.call();
      _fitBounds();
      return;
    }

    _notifyRouteSelected(vm);
    _fitBounds();
  }

  void _notifyRouteSelected(TransportRouteMapViewModel vm) {
    final route = vm.selectedRoute;
    if (route == null || widget.onRouteSelected == null) return;
    widget.onRouteSelected!(RouteInfo(
      distanceKm: route.distanceKm,
      durationMinutes: route.durationMinutes,
      distanceText: route.distanceText,
      durationText: route.durationText,
      summary: route.summary,
    ));
  }

  void _selectRoute(TransportRouteMapViewModel vm, int index) {
    vm.selectRoute(index);
    _notifyRouteSelected(vm);
  }

  Set<Polyline> _buildPolylines(TransportRouteMapViewModel vm) {
    if (!vm.routeLoaded) return {};

    final polylines = <Polyline>{};

    // Unselected routes (behind, grey, dashed)
    for (int i = 0; i < vm.routes.length; i++) {
      if (i == vm.selectedIndex) continue;
      final capturedIndex = i;
      polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: vm.routes[i].points,
        color: context.ext.shimmerBase,
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        consumeTapEvents: true,
        onTap: () => _selectRoute(vm, capturedIndex),
      ));
    }

    // Selected route (on top, blue, solid)
    polylines.add(Polyline(
      polylineId: PolylineId('route_selected_${vm.selectedIndex}'),
      points: vm.routes[vm.selectedIndex].points,
      color: context.colors.secondary,
      width: 5,
    ));

    return polylines;
  }

  void _fitBounds() {
    if (_controller == null) return;

    final south = min(_pickup.latitude, _dropoff.latitude);
    final north = max(_pickup.latitude, _dropoff.latitude);
    final west = min(_pickup.longitude, _dropoff.longitude);
    final east = max(_pickup.longitude, _dropoff.longitude);

    _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midLat = (_pickup.latitude + _dropoff.latitude) / 2;
    final midLng = (_pickup.longitude + _dropoff.longitude) / 2;
    final vm = context.watch<TransportRouteMapViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: SizedBox(
            height: widget.height,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(midLat, midLng),
                zoom: 10,
              ),
              markers: _markers,
              polylines: _buildPolylines(vm),
              onMapCreated: (controller) {
                _controller = controller;
                if (vm.routeLoaded) _fitBounds();
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
            ),
          ),
        ),
        if (vm.routes.length > 1) ...[
          const SizedBox(height: AppSpacing.m),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: vm.routes.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
              itemBuilder: (context, index) {
                final route = vm.routes[index];
                final isSelected = index == vm.selectedIndex;
                return _routeCard(vm, route, index, isSelected);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _routeCard(TransportRouteMapViewModel vm, DirectionsRoute route, int index, bool isSelected) {
    return Semantics(
      button: true,
      label: 'Select route ${index + 1}',
      child: GestureDetector(
        onTap: () => _selectRoute(vm, index),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.ms),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.secondary : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: isSelected ? context.colors.secondary : context.colors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.secondary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              route.summary.isNotEmpty ? route.summary : tr('transport_route_number', namedArgs: {'number': '${index + 1}'}),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? context.colors.onSecondary : context.colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${route.distanceText} \u2022 ${route.durationText}',
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? context.colors.onSecondary.withValues(alpha: 0.7) : context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
