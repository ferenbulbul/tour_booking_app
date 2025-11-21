import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapTestPage extends StatelessWidget {
  const GoogleMapTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps Test")),
      body: const GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(41.0082, 28.9784), // İstanbul
          zoom: 14,
        ),
      ),
    );
  }
}
