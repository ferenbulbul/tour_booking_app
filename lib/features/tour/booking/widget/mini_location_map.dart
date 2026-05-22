// lib/features/tour/booking/widget/mini_location_map.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class MiniLocationMap extends StatefulWidget {
  final double lat;
  final double lng;
  final VoidCallback onTap;

  const MiniLocationMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.onTap,
  });

  @override
  State<MiniLocationMap> createState() => _MiniLocationMapState();
}

class _MiniLocationMapState extends State<MiniLocationMap> {
  GoogleMapController? _controller;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = _buildMarkers();
  }

  @override
  void didUpdateWidget(covariant MiniLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _markers = _buildMarkers();
      _controller?.moveCamera(
        CameraUpdate.newLatLng(LatLng(widget.lat, widget.lng)),
      );
    }
  }

  Set<Marker> _buildMarkers() {
    final pos = LatLng(widget.lat, widget.lng);
    return {
      Marker(
        markerId: const MarkerId("selected"),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(widget.lat, widget.lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: pos, zoom: 16),
              markers: _markers,
              onMapCreated: (controller) => _controller = controller,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              liteModeEnabled: Platform.isAndroid,
            ),
            // Tap overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Semantics(
                  button: true,
                  label: 'Open map location',
                  child: InkWell(onTap: widget.onTap),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
