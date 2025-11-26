import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniLocationMap extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final pos = LatLng(lat, lng);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: Stack(
            children: [
              // GOOGLE MAP → dokunmayı kapatıyoruz
              IgnorePointer(
                ignoring: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pos,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: pos,
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),

              // ŞEFFAF TIKLANABİLİR KATMAN
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ALT BİLGİ YAZISI
        Text(
          "📍 Kalkış noktanızı büyük haritada görüntüleyin",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
