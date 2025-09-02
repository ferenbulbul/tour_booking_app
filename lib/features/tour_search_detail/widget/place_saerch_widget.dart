// lib/features/place_picker/place_picker_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class PlacePickerPage extends StatefulWidget {
  const PlacePickerPage({super.key});

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  final _ctrl = TextEditingController();
  final _debouncer = _Debouncer(ms: 350);
  final _apiKey = Keys.places;

  bool _loading = false;
  List<_Prediction> _items = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (_apiKey.isEmpty) {
      _snack("API anahtarı boş (.env yüklü mü?)");
      return;
    }
    if (q.isEmpty) {
      setState(() => _items = []);
      return;
    }
    setState(() => _loading = true);

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': q,
        'key': _apiKey,
        'language': 'tr',
        'components': 'country:tr',
      },
    );

    final res = await http.get(uri);
    setState(() => _loading = false);

    if (res.statusCode != 200) {
      _snack('Autocomplete hata: ${res.statusCode}');
      return;
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != 'OK') {
      _snack('Autocomplete status: $status');
      setState(() => _items = []);
      return;
    }

    final preds = (body['predictions'] as List)
        .map((e) => _Prediction.fromJson(e))
        .toList();

    setState(() => _items = preds);
  }

  Future<void> _pick(_Prediction p) async {
    // Place details ile lat/lng al
    final uri =
        Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
          'place_id': p.placeId,
          'key': _apiKey,
          'language': 'tr',
          'fields': 'formatted_address,name,geometry/location',
        });
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      _snack('Beklenmeyen bir hata oluştu');
      return;
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != 'OK') {
      _snack('Details status: $status');
      return;
    }
    final result = body['result'] as Map<String, dynamic>;
    final location =
        (result['geometry']?['location'] ?? {}) as Map<String, dynamic>;
    final lat = (location['lat'] as num?)?.toDouble();
    final lng = (location['lng'] as num?)?.toDouble();

    Navigator.of(
      context,
    ).pop(PlaceSelection(description: p.description, lat: lat, lng: lng));
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konum Seç')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Arama kutusu
            TextField(
              controller: _ctrl,
              onChanged: (v) => _debouncer(() => _search(v)),
              decoration: InputDecoration(
                hintText: 'Konum ara (ör. Kanyon AVM, Ataşehir...)',
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

            // Durum satırı
            if (_loading) const LinearProgressIndicator(),

            // Sonuç listesi (şık kart)
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Sonuç yok. Yazmaya başlayın.'))
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = _items[i];
                        return Material(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 1,
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
    final sf = (j['structured_formatting'] ?? {}) as Map<String, dynamic>;
    return _Prediction(
      placeId: j['place_id'] as String,
      description: j['description'] as String,
      mainText: (sf['main_text'] ?? j['description']) as String,
      secondaryText: sf['secondary_text'] as String?,
    );
  }
}

class _Debouncer {
  final int ms;
  Timer? _t;
  _Debouncer({this.ms = 300});
  void call(void Function() action) {
    _t?.cancel();
    _t = Timer(Duration(milliseconds: ms), action);
  }
}
