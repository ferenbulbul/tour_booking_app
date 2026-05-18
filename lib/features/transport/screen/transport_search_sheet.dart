import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';

class TransportSearchSheet extends StatefulWidget {
  final String apiKey;
  final String? cityBias;
  final LatLng? cityCenter;
  final String? cityName;
  final String hintText;
  final Color iconColor;

  const TransportSearchSheet({
    super.key,
    required this.apiKey,
    this.cityBias,
    this.cityCenter,
    this.cityName,
    required this.hintText,
    required this.iconColor,
  });

  @override
  State<TransportSearchSheet> createState() => _TransportSearchSheetState();
}

class _TransportSearchSheetState extends State<TransportSearchSheet> {
  final _ctrl = TextEditingController();
  List<PlacePrediction> _predictions = [];
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() => _predictions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchPredictions(value.trim());
    });
  }

  Future<void> _fetchPredictions(String input) async {
    final base =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&key=${widget.apiKey}'
        '&language=tr'
        '&components=country:tr';

    final location = widget.cityCenter;
    final url = location != null
        ? '$base&location=${location.latitude},${location.longitude}&radius=50000'
        : base;

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return;
      final data = json.decode(res.body);
      if (data['status'] != 'OK') return;

      final list = (data['predictions'] as List)
          .map((e) => PlacePrediction.fromJson(e))
          .toList();

      if (mounted) setState(() => _predictions = list);
    } catch (_) {}
  }

  Future<void> _selectPlace(PlacePrediction prediction) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=${prediction.placeId}'
        '&fields=geometry'
        '&key=${widget.apiKey}';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return;
      final data = json.decode(res.body);
      if (data['status'] != 'OK') return;

      final loc = data['result']['geometry']['location'];
      if (!mounted) return;

      Navigator.pop(
        context,
        PlaceResult(
          lat: loc['lat'],
          lng: loc['lng'],
          address: prediction.description,
        ),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final screenH = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenH * 0.45,
        maxHeight: screenH * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                onChanged: _onChanged,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  prefixIcon: Icon(SolarIconsOutline.magnifier,
                      size: 22, color: widget.iconColor),
                  suffixIcon: _ctrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(SolarIconsOutline.closeCircle, size: 20),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() => _predictions = []);
                          },
                        )
                      : null,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Results
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final p = _predictions[index];
                return ListTile(
                  leading: Icon(
                    SolarIconsOutline.mapPoint,
                    size: 20,
                    color: widget.iconColor,
                  ),
                  title: Text(
                    p.mainText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: p.secondaryText != null
                      ? Text(
                          p.secondaryText!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () => _selectPlace(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
