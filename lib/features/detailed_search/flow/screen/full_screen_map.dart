import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/keys.dart';

class FullMapView extends StatefulWidget {
  final double lat;
  final double lng;
  final String city; // Örn: Trabzon
  final String district; // Örn: Ortahisar

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
  String? debugJson;

  @override
  void initState() {
    super.initState();
    selectedPos = LatLng(widget.lat, widget.lng);
    markers = {
      Marker(markerId: const MarkerId("selected"), position: selectedPos),
    };
  }

  // -------------------------------------------------------------
  // 🔥 CITY EXTRACTOR (Asla boş dönmez)
  // -------------------------------------------------------------
  String extractCity(List<dynamic> comps) {
    for (final c in comps) {
      final types = List<String>.from(c["types"]);
      if (types.contains("administrative_area_level_1")) {
        return c["long_name"];
      }
    }
    return ""; // fallback
  }

  // -------------------------------------------------------------
  // 🔥 DISTRICT EXTRACTOR (TYPE Priority)
  // -------------------------------------------------------------
  String extractDistrict(List<dynamic> comps) {
    String? level2;
    String? level3;
    String? locality;
    String? sublocality;

    for (final c in comps) {
      final t = List<String>.from(c["types"]);
      final name = c["long_name"];

      if (t.contains("administrative_area_level_2")) level2 = name;
      if (t.contains("administrative_area_level_3")) level3 = name;
      if (t.contains("locality")) locality = name;
      if (t.contains("sublocality") || t.contains("sublocality_level_1")) {
        sublocality = name;
      }
    }

    return level2 ?? level3 ?? locality ?? sublocality ?? "";
  }

  // -------------------------------------------------------------
  // 🔥 FALLBACK: formatted_address → district çıkar
  // -------------------------------------------------------------
  String? extractDistrictFromFormatted(String formatted) {
    final reg = RegExp(
      r"(\d{4,5}\s*)?([A-Za-zÇçĞğİıÖöŞşÜü\s]+)\/[A-Za-zÇçĞğİıÖöŞşÜü\s]+",
    );

    final m = reg.firstMatch(formatted);
    if (m != null) {
      return m.group(2)?.trim();
    }
    return null;
  }

  // -------------------------------------------------------------
  // 🔥 DISTRICT TOTAL SOLVER
  // -------------------------------------------------------------
  String resolveDistrict(List<dynamic> comps, String formatted) {
    final d1 = extractDistrict(comps);
    if (d1.isNotEmpty) return d1;

    final d2 = extractDistrictFromFormatted(formatted);
    if (d2 != null && d2.isNotEmpty) return d2;

    return "";
  }

  // -------------------------------------------------------------
  // 🔥 NORMALIZATION (EN KRİTİK)
  // -------------------------------------------------------------
  String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll("province", "")
        .replaceAll("district", "")
        .replaceAll("municipality", "")
        .replaceAll("belediyesi", "")
        .replaceAll("belediy", "")
        .replaceAll("ilçe", "")
        .replaceAll("il", "")
        .trim();
  }

  // -------------------------------------------------------------
  // 🔥 GOOGLE REVERSE GEOCODE
  // -------------------------------------------------------------
  Future<Map<String, dynamic>?> getAddressDetails(LatLng pos) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$_apiKey&language=tr";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return null;

    final data = json.decode(res.body);
    if (data["status"] != "OK") return null;

    return data["results"][0];
  }

  // -------------------------------------------------------------
  // 🔥 BUILD
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konum Seç")),
      body: Stack(
        children: [
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

              debugJson = const JsonEncoder.withIndent("  ").convert(comps);

              // -------------------------------------------------------------------
              // 🔥 TEK MERKEZİ DOĞRULAMA (AUTOCOMPLETE İLE %100 AYNI MANTIK)
              // -------------------------------------------------------------------
              final validation = LocationValidator.validate(
                components: comps,
                formatted: formatted,
                expectedCity: widget.city,
                expectedDistrict: widget.district,
              );

              if (!validation.isValid) {
                setState(() {
                  warningMessage = validation.errorMessage;
                });
                return;
              }

              // -------------------------------------------------------------------
              // ✔ GEÇERLİ KONUM — Marker ve adresi güncelle
              // -------------------------------------------------------------------
              if (!mounted) return;
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

          if (selectedAddress != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _addressCard(selectedAddress!),
            ),

          if (warningMessage != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: _warningBanner(warningMessage!),
            ),

          // if (debugJson != null)
          //   Positioned(
          //     bottom: 100,
          //     left: 10,
          //     right: 10,
          //     height: 250,
          //     child: _debugPanel(debugJson!),
          //   ),
        ],
      ),
    );
  }

  Widget _addressCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _warningBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _debugPanel(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _card().copyWith(color: Colors.black.withOpacity(0.85)),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
        ),
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
