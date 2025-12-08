// lib/features/place_picker/place_picker_page.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class PlacePickerPage extends StatefulWidget {
  final String city; // Örn: "İstanbul"
  final String district; // Örn: "Bağcılar"

  const PlacePickerPage({
    super.key,
    required this.city,
    required this.district,
  });

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  final _ctrl = TextEditingController();
  final _debouncer = _Debouncer(ms: 300);

  final _apiKey = Keys.places;

  bool _loading = false;
  List<_Prediction> _items = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Sayfa açılır açılmaz şehir ile arama yap
    Future.microtask(() => _search(""));
  }

  // ---------------------------------------------------------------------------
  // AUTOCOMPLETE SEARCH
  // ---------------------------------------------------------------------------
  Future<void> _search(String query) async {
    // Her koşulda şehir + ilçe başta olacak
    final q = "${widget.city} ${widget.district} $query".trim();

    setState(() => _loading = true);

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {'input': q, 'key': _apiKey, 'language': 'tr'},
    );

    final res = await http.get(uri);
    setState(() => _loading = false);

    if (res.statusCode != 200) {
      setState(() => _items = []);
      return;
    }

    final body = jsonDecode(res.body);
    if (body['status'] != "OK") {
      setState(() => _items = []);
      return;
    }

    final preds = (body['predictions'] as List)
        .map((e) => _Prediction.fromJson(e))
        .toList();

    setState(() => _items = preds);
  }

  // ---------------------------------------------------------------------------
  // PLACE DETAILS → lat/lng
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  //  CLEAN PICK FUNCTION (MAP İLE AYNI MİMARI)
  // ---------------------------------------------------------------------------
  Future<void> _pick(_Prediction p) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': p.placeId,
        'key': _apiKey,
        'language': 'tr',
        'fields': 'formatted_address,name,geometry/location,address_components',
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return;

    final body = jsonDecode(res.body);
    if (body['status'] != 'OK') return;

    final result = body['result'];

    final components = result['address_components'] as List<dynamic>;
    final formatted = result['formatted_address'] ?? '';

    // -----------------------------------------------------------
    // 🔥 MERKEZİ DOĞRULAMA — ARTIK TEK BEYİN BURADA
    // -----------------------------------------------------------
    final validation = LocationValidator.validate(
      components: components,
      formatted: formatted,
      expectedCity: widget.city,
      expectedDistrict: widget.district,
    );

    if (!validation.isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validation.errorMessage!)));
      return;
    }

    // -----------------------------------------------------------
    // 🔥 KOORDİNATLARI AL
    // -----------------------------------------------------------
    final loc = result['geometry']?['location'];
    final lat = (loc?['lat'] as num?)?.toDouble();
    final lng = (loc?['lng'] as num?)?.toDouble();

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konum koordinatları alınamadı.")),
      );
      return;
    }

    // -----------------------------------------------------------
    // 🔥 BAŞARILI → GERİ DÖN
    // -----------------------------------------------------------
    Navigator.of(
      context,
    ).pop(PlaceSelection(description: p.description, lat: lat, lng: lng));
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.city} / ${widget.district} seç")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Arama kutusu
            TextField(
              controller: _ctrl,
              onChanged: (v) => _debouncer(() => _search(v)),
              decoration: InputDecoration(
                hintText: "${widget.city} ${widget.district} içinde ara...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _ctrl.clear();
                          setState(() => _items = []);
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_loading) const LinearProgressIndicator(),

            // 🔽 Sonuç listesi
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Sonuç bulunamadı'))
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = _items[i];
                        return Material(
                          elevation: 1,
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(
                              p.mainText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(p.secondaryText ?? ''),
                            onTap: () => _pick(p),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Prediction DTO
class _Prediction {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  _Prediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  factory _Prediction.fromJson(Map<String, dynamic> j) {
    final sf = (j['structured_formatting'] ?? {});
    return _Prediction(
      placeId: j['place_id'],
      description: j['description'],
      mainText: sf['main_text'] ?? j['description'],
      secondaryText: sf['secondary_text'],
    );
  }
}

// 🔹 Debouncer
class _Debouncer {
  final int ms;
  Timer? _t;
  _Debouncer({this.ms = 300});
  void call(void Function() action) {
    _t?.cancel();
    _t = Timer(Duration(milliseconds: ms), action);
  }
}
