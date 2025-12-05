import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void _forceCenterMap() {
    if (!mounted || _controller == null) return;
    final pos = LatLng(widget.lat, widget.lng);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 250), () {
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 16)),
        );

        // Marker'ı garanti çizdir
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void didUpdateWidget(covariant MiniLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _forceCenterMap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(widget.lat, widget.lng);
    final markerId =
        "pin_${widget.lat}_${widget.lng}_${DateTime.now().millisecondsSinceEpoch}";

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: pos, zoom: 15),
              markers: {Marker(markerId: MarkerId(markerId), position: pos)},
              onMapCreated: (c) {
                _controller = c;
                _forceCenterMap();
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              liteModeEnabled: false,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: widget.onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
