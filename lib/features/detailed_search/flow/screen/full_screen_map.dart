import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/keys.dart';
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

final _apiKey = Keys.places;

class _FullMapViewState extends State<FullMapView> {
  late LatLng selectedPos;
  Set<Marker> markers = {};

  String? selectedAddress;
  String? warningMessage;

  @override
  void initState() {
    super.initState();
    selectedPos = LatLng(widget.lat, widget.lng);
    markers = {
      Marker(markerId: const MarkerId("initial"), position: selectedPos),
    };
  }

  Future<Map<String, dynamic>?> getAddressDetails(LatLng pos) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$_apiKey&language=tr";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return null;

    final data = json.decode(res.body);
    if (data["status"] != "OK") return null;

    return data["results"][0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Konum Seç", showBack: true),
      body: Stack(
        children: [
          // ---------------- GOOGLE MAP ----------------
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedPos,
              zoom: 16,
            ),
            markers: markers,
            onTap: (LatLng newPos) async {
              final result = await getAddressDetails(newPos);
              if (result == null) return;

              final comps = result["address_components"];
              final formatted = result["formatted_address"];

              final validation = LocationValidator.validate(
                components: comps,
                formatted: formatted,
                expectedCity: widget.city,
                expectedDistrict: widget.district,
              );

              if (!validation.isValid) {
                setState(() => warningMessage = validation.errorMessage);
                return;
              }

              setState(() {
                warningMessage = null;
                selectedPos = newPos;
                selectedAddress = formatted;

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
            top: 15,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: warningMessage != null ? 1 : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: warningMessage != null
                    ? Offset.zero
                    : const Offset(0, -0.3),
                child: warningMessage == null
                    ? const SizedBox.shrink()
                    : _warningBanner(warningMessage!),
              ),
            ),
          ),

          // ---------------- ALT BİLGİ / ALT BUTON ----------------
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: selectedAddress == null
                  ? _bottomInfoMessage() // İlk açılış → bilgi
                  : _confirmButton(), // Kullanıcı seçince → buton
            ),
          ),

          // ---------------- ADRES KARTI ----------------
          if (selectedAddress != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 90,
              child: _addressCard(selectedAddress!),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 📌 ALTTA GÖRÜNEN BİLGİ
  // ----------------------------------------------------------
  Widget _bottomInfoMessage() {
    return Container(
      key: const ValueKey("info"),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        "Haritaya dokunarak bir konum seçebilirsiniz.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ----------------------------------------------------------
  // 📌 KONUMU KULLAN BUTONU
  // ----------------------------------------------------------
  Widget _confirmButton() {
    return ElevatedButton(
      key: const ValueKey("button"),

      onPressed: () {
        Navigator.pop(
          context,
          PlaceSelection(
            description: selectedAddress!,
            lat: selectedPos.latitude,
            lng: selectedPos.longitude,
          ),
        );
      },
      child: const Text(
        "Bu Konumu Kullan",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ----------------------------------------------------------
  // 📌 ADRES KARTI
  // ----------------------------------------------------------
  Widget _addressCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }

  // ----------------------------------------------------------
  // 📌 WARNING BANNER
  // ----------------------------------------------------------
  Widget _warningBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  BoxDecoration _card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
    );
  }
}
