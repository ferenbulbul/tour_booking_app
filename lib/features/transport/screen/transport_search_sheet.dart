import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/transport/transport_search_viewmodel.dart';

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
      context.read<TransportSearchViewModel>().clearPredictions();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<TransportSearchViewModel>().fetchPredictions(
            input: value.trim(),
            apiKey: widget.apiKey,
            cityCenter: widget.cityCenter,
          );
    });
  }

  Future<void> _selectPlace(PlacePrediction prediction) async {
    final vm = context.read<TransportSearchViewModel>();
    final result = await vm.selectPlace(prediction);
    if (result == null || !mounted) return;

    Navigator.pop(
      context,
      PlaceResult(
        lat: result.lat,
        lng: result.lng,
        address: prediction.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenH = MediaQuery.of(context).size.height;
    final vm = context.watch<TransportSearchViewModel>();

    return Container(
      constraints: BoxConstraints(
        minHeight: screenH * 0.45,
        maxHeight: screenH * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: AppSpacing.ms),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.ext.textLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                onChanged: _onChanged,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  prefixIcon: Icon(SolarIconsOutline.magnifier,
                      size: AppIconSize.lm, color: widget.iconColor, semanticLabel: 'Search'),
                  suffixIcon: _ctrl.text.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(SolarIconsOutline.closeCircle, size: AppIconSize.l, semanticLabel: 'Clear'),
                          onPressed: () {
                            _ctrl.clear();
                            vm.clearPredictions();
                          },
                        )
                      : null,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: context.ext.textLight,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.ml,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s),

          // Results
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              itemCount: vm.predictions.length,
              itemBuilder: (context, index) {
                final p = vm.predictions[index];
                return ListTile(
                  leading: Icon(
                    SolarIconsOutline.mapPoint,
                    size: AppIconSize.l,
                    color: widget.iconColor,
                    semanticLabel: 'Location',
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
                            color: context.colors.onSurfaceVariant,
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
