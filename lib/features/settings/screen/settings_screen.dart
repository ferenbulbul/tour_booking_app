// lib/places_demo_page.dart
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:tour_booking/keys.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Konum Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: Keys.places, // dart-define ile geliyor
              inputDecoration: const InputDecoration(
                hintText: "Konum ara (örn. Kanyon AVM, Ataşehir...)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place_outlined),
              ),
              debounceTime: 400,
              countries: ["tr"], // sadece Türkiye sonuçları
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction p) {
                debugPrint("📍 Seçilen: ${p.description}");
                debugPrint("   Koordinatlar: ${p.lat}, ${p.lng}");
                debugPrint(
                  "   Tipler: lat=${p.lat.runtimeType}, lng=${p.lng.runtimeType}",
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Seçilen: ${p.description}")),
                );
              },
              itemClick: (Prediction p) {
                controller.text = p.description ?? "";
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
              seperatedBuilder: const Divider(),
              itemBuilder: (context, index, Prediction p) {
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(p.description ?? ""),
                  subtitle: p.lat != null && p.lng != null
                      ? Text("(${p.lat}, ${p.lng})")
                      : null,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Yazmaya başla, Google Places önerileri otomatik gelecek.\n"
              "Birini seçince description + lat/lng loglarda ve snackbar’da görünür.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
