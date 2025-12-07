// lib/features/detailed_search/flow/widget/mini_location_map.dart

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
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarker();
  }

  @override
  void didUpdateWidget(covariant MiniLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _updateMarkerAndCamera();
    }
  }

  void _updateMarker() {
    final pos = LatLng(widget.lat, widget.lng);
    final markerId = MarkerId("selected_${widget.lat}_${widget.lng}");

    setState(() {
      _markers = {
        Marker(
          markerId: markerId,
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  void _updateMarkerAndCamera() {
    _updateMarker();

    if (_controller != null) {
      final pos = LatLng(widget.lat, widget.lng);

      // Kamera + marker'ı garantiye al
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted || _controller == null) return;

          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: pos, zoom: 16.0),
            ),
          );

          // Ekstra sigorta: 400ms sonra tekrar zorla
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted && _controller != null) {
              _controller!.animateCamera(CameraUpdate.newLatLng(pos));
              // Marker'ı tekrar tetikle
              _updateMarker();
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(widget.lat, widget.lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            GoogleMap(
              // KEY YOK → Dışarıdan sabit key verilecek (ValueKey("mini_map_fixed"))
              initialCameraPosition: CameraPosition(target: pos, zoom: 10),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _updateMarkerAndCamera();
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              liteModeEnabled: false,
            ),

            // Tıklanabilir alan
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: widget.onTap),
              ),
            ),

            // Positioned(
            //   top: 8,
            //   right: 8,
            //   child: FloatingActionButton.small(
            //     heroTag: "open_full_map",
            //     backgroundColor: Colors.white,
            //     child: const Icon(Icons.fullscreen, color: Colors.black87),
            //     onPressed: widget.onTap,
            //   ),
            // ),
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
