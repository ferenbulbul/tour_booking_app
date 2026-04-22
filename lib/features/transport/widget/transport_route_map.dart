import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/keys.dart';

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
  Set<Polyline> _polylines = {};
  bool _routeLoaded = false;

  List<_ParsedRoute> _routes = [];
  int _selectedIndex = 0;

  LatLng get _pickup => LatLng(widget.pickupLat, widget.pickupLng);
  LatLng get _dropoff => LatLng(widget.dropoffLat, widget.dropoffLng);

  @override
  void initState() {
    super.initState();
    _setupMarkers();
    if (widget.fetchRoute) _fetchRoutes();
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
    try {
      final origin = '${widget.pickupLat},${widget.pickupLng}';
      final dest = '${widget.dropoffLat},${widget.dropoffLng}';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$origin'
        '&destination=$dest'
        '&mode=driving'
        '&alternatives=true'
        '&key=${Keys.places}',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) {
        widget.onRouteFetchFailed?.call();
        return;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') {
        widget.onRouteFetchFailed?.call();
        return;
      }

      final routesJson = data['routes'] as List<dynamic>;
      final parsed = <_ParsedRoute>[];

      for (final route in routesJson) {
        final leg = (route['legs'] as List<dynamic>)[0];
        final distanceValue = (leg['distance']['value'] as num).toDouble();
        final durationValue = (leg['duration']['value'] as num).toInt();
        final distanceText = leg['distance']['text'] as String;
        final durationText = leg['duration']['text'] as String;
        final summary = (route['summary'] as String?) ?? '';

        final encodedPolyline =
            route['overview_polyline']['points'] as String;
        final points = _decodePolyline(encodedPolyline);

        parsed.add(_ParsedRoute(
          points: points,
          distanceKm: distanceValue / 1000.0,
          durationMinutes: (durationValue / 60.0).round(),
          distanceText: distanceText,
          durationText: durationText,
          summary: summary,
        ));
      }

      if (parsed.isEmpty || !mounted) {
        widget.onRouteFetchFailed?.call();
        return;
      }

      // Find the route closest to initialDistanceKm if provided
      int bestIndex = 0;
      if (widget.initialDistanceKm != null && parsed.length > 1) {
        double minDiff = double.infinity;
        for (int i = 0; i < parsed.length; i++) {
          final diff = (parsed[i].distanceKm - widget.initialDistanceKm!).abs();
          if (diff < minDiff) {
            minDiff = diff;
            bestIndex = i;
          }
        }
      }

      setState(() {
        _routes = parsed;
        _selectedIndex = bestIndex;
        _routeLoaded = true;
        _buildPolylines();
      });

      _notifyRouteSelected();
      _fitBounds();
    } catch (_) {
      if (mounted) {
        _fitBounds();
        widget.onRouteFetchFailed?.call();
      }
    }
  }

  void _selectRoute(int index) {
    if (index == _selectedIndex || index < 0 || index >= _routes.length) return;
    setState(() {
      _selectedIndex = index;
      _buildPolylines();
    });
    _notifyRouteSelected();
  }

  void _notifyRouteSelected() {
    if (_routes.isEmpty || widget.onRouteSelected == null) return;
    final r = _routes[_selectedIndex];
    widget.onRouteSelected!(RouteInfo(
      distanceKm: r.distanceKm,
      durationMinutes: r.durationMinutes,
      distanceText: r.distanceText,
      durationText: r.durationText,
      summary: r.summary,
    ));
  }

  void _buildPolylines() {
    final polylines = <Polyline>{};

    // Unselected routes (behind, grey, dashed)
    for (int i = 0; i < _routes.length; i++) {
      if (i == _selectedIndex) continue;
      polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: _routes[i].points,
        color: Colors.grey.shade400,
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        consumeTapEvents: true,
        onTap: () => _selectRoute(i),
      ));
    }

    // Selected route (on top, blue, solid)
    polylines.add(Polyline(
      polylineId: PolylineId('route_selected_$_selectedIndex'),
      points: _routes[_selectedIndex].points,
      color: AppColors.primary,
      width: 5,
    ));

    _polylines = polylines;
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: widget.height,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(midLat, midLng),
                zoom: 10,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _controller = controller;
                if (_routeLoaded) _fitBounds();
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
        if (_routes.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _routes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final route = _routes[index];
                final isSelected = index == _selectedIndex;
                return _routeCard(route, index, isSelected);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _routeCard(_ParsedRoute route, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectRoute(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
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
              route.summary.isNotEmpty ? route.summary : 'Rota ${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${route.distanceText} \u2022 ${route.durationText}',
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParsedRoute {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;
  final String summary;

  const _ParsedRoute({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
    required this.summary,
  });
}
