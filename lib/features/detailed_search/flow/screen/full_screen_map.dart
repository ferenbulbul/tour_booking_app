import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullMapView extends StatelessWidget {
  final double lat;
  final double lng;

  const FullMapView({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(title: const Text("Konumu Gör")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: pos, zoom: 16),
        markers: {
          Marker(markerId: const MarkerId("selected_big"), position: pos),
        },
      ),
    );
  }
}
