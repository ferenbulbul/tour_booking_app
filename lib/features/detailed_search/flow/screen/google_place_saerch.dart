// lib/features/place_picker/place_picker_page.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class PlacePickerPage extends StatefulWidget {
  final String city;
  final String district;

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
    Future.microtask(() => _search(""));
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------
  Future<void> _search(String query) async {
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

    setState(() {
      _items = (body['predictions'] as List)
          .map((e) => _Prediction.fromJson(e))
          .toList();
    });
  }

  // ---------------------------------------------------------------------------
  // PICK PLACE
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

    final loc = result['geometry']?['location'];
    final lat = (loc?['lat'] as num?)?.toDouble();
    final lng = (loc?['lng'] as num?)?.toDouble();

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konum koordinatları alınamadı.")),
      );
      return;
    }

    Navigator.pop(
      context,
      PlaceSelection(description: p.description, lat: lat, lng: lng),
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ✔ PREMIUM COMMON APP BAR
      appBar: CommonAppBar(
        title: "${widget.city} / ${widget.district}",
        showBack: true,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------------------------------------------------------------------
            // PREMIUM SEARCH FIELD (blur yok, soft border, radius)
            // -------------------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border.withOpacity(.4)),
              ),
              child: TextField(
                controller: _ctrl,
                onChanged: (v) => _debouncer(() => _search(v)),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  suffixIcon: _ctrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() => _items = []);
                          },
                        )
                      : null,
                  hintText: "${widget.city} ${widget.district} içinde ara...",
                  hintStyle: TextStyle(color: AppColors.textLight),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_loading)
              LinearProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(.2),
              ),

            // -------------------------------------------------------------------
            // RESULTS LIST (premium card style)
            // -------------------------------------------------------------------
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Text(
                        "Sonuç bulunamadı",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final p = _items[i];
                        return InkWell(
                          onTap: () => _pick(p),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.mainText,
                                        style: AppTextStyles.titleSmall
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                      if (p.secondaryText != null)
                                        Text(
                                          p.secondaryText!,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
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

// ---------------------------------------------------------------------------
// Prediction DTO
// ---------------------------------------------------------------------------
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
    final sf = j['structured_formatting'] ?? {};
    return _Prediction(
      placeId: j['place_id'],
      description: j['description'],
      mainText: sf['main_text'] ?? j['description'],
      secondaryText: sf['secondary_text'],
    );
  }
}

// ---------------------------------------------------------------------------
// Debouncer
// ---------------------------------------------------------------------------
class _Debouncer {
  final int ms;
  Timer? _t;
  _Debouncer({this.ms = 300});

  void call(void Function() action) {
    _t?.cancel();
    _t = Timer(Duration(milliseconds: ms), action);
  }
}
