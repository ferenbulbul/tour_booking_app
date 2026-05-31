import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';

class TransportSearchSheet extends StatefulWidget {
  final String apiKey;
  final LatLng? cityCenter;
  final String? cityName;

  /// true → pickup: city name prepended to query, strict bounds
  /// false → dropoff: city name used for initial results only, no restriction
  final bool restrictToCity;
  final String hintText;
  final Color iconColor;
  final List<TransportSuggestedLocation> suggestedLocations;

  const TransportSearchSheet({
    super.key,
    required this.apiKey,
    this.cityCenter,
    this.cityName,
    this.restrictToCity = false,
    required this.hintText,
    required this.iconColor,
    this.suggestedLocations = const [],
  });

  @override
  State<TransportSearchSheet> createState() => _TransportSearchSheetState();
}

class _TransportSearchSheetState extends State<TransportSearchSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Auto-fetch initial results using city name
    if (widget.cityName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _fetchInitial();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Fetches default results for the city (empty input).
  void _fetchInitial() {
    context.read<TransportSearchViewModel>().fetchPredictions(
          input: '',
          apiKey: widget.apiKey,
          cityCenter: widget.cityCenter,
          cityName: widget.restrictToCity ? widget.cityName : null,
          initialCityQuery: !widget.restrictToCity ? widget.cityName : null,
        );
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      if (widget.cityName != null) {
        _fetchInitial();
      } else {
        context.read<TransportSearchViewModel>().clearPredictions();
      }
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<TransportSearchViewModel>().fetchPredictions(
            input: value.trim(),
            apiKey: widget.apiKey,
            cityCenter: widget.cityCenter,
            cityName: widget.restrictToCity ? widget.cityName : null,
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

  void _selectSuggested(TransportSuggestedLocation loc) {
    Navigator.pop(
      context,
      PlaceResult(
        lat: loc.latitude,
        lng: loc.longitude,
        address: loc.name,
      ),
    );
  }

  bool _locationLoading = false;

  Future<void> _useCurrentLocation() async {
    if (_locationLoading) return;
    setState(() => _locationLoading = true);

    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission effectivePermission = permission;
      if (permission == LocationPermission.denied) {
        effectivePermission = await Geolocator.requestPermission();
      }
      if (effectivePermission == LocationPermission.denied ||
          effectivePermission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locationLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      String address = '${position.latitude}, ${position.longitude}';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [p.thoroughfare, p.subLocality, p.locality]
              .where((s) => s != null && s.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) address = parts.join(', ');
        }
      } catch (_) {}

      if (!mounted) return;
      Navigator.pop(
        context,
        PlaceResult(
          lat: position.latitude,
          lng: position.longitude,
          address: address,
        ),
      );
    } catch (e) {
      debugPrint('TransportSearchSheet._useCurrentLocation: $e');
      if (mounted) setState(() => _locationLoading = false);
    }
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
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
                      size: AppIconSize.lm,
                      color: widget.iconColor,
                      semanticLabel: 'Search'),
                  suffixIcon: _ctrl.text.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(SolarIconsOutline.closeCircle,
                              size: AppIconSize.l, semanticLabel: 'Clear'),
                          onPressed: () {
                            _ctrl.clear();
                            if (widget.cityName != null) {
                              _fetchInitial();
                            } else {
                              vm.clearPredictions();
                            }
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

          // Single scrollable list: location tile + predictions/suggested
          Flexible(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              children: [
                // Always-visible "Use My Location" tile
                _buildCurrentLocationTile(context),

                // Predictions or suggested locations (only after initial load)
                if (vm.predictions.isNotEmpty)
                  ...vm.predictions.map((p) => ListTile(
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
                                  color:
                                      context.colors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () => _selectPlace(p),
                      ))
                else if (vm.initialLoaded &&
                    widget.suggestedLocations.isNotEmpty)
                  ..._buildSuggestedItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationTile(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.colors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: _locationLoading
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.ms),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.secondary,
                ),
              )
            : Icon(
                SolarIconsOutline.gps,
                size: AppIconSize.ml,
                color: context.colors.secondary,
              ),
      ),
      title: Text(
        tr('transport_use_my_location'),
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.secondary,
        ),
      ),
      onTap: _useCurrentLocation,
    );
  }

  List<Widget> _buildSuggestedItems(BuildContext context) {
    final locations = widget.suggestedLocations;
    return [
      Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.s,
          top: AppSpacing.s,
          bottom: AppSpacing.ms,
        ),
        child: Row(
          children: [
            Icon(
              SolarIconsOutline.starFallMinimalistic2,
              size: AppIconSize.ml,
              color: context.colors.secondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              tr('transport_suggested_locations'),
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      ...locations.map((loc) => _suggestedTile(context, loc)),
    ];
  }

  Widget _suggestedTile(
      BuildContext context, TransportSuggestedLocation loc) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: () => _selectSuggested(loc),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.ms,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Icon(
                SolarIconsOutline.mapPoint,
                size: AppIconSize.ml,
                color: widget.iconColor,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (loc.description != null &&
                      loc.description!.isNotEmpty)
                    Text(
                      loc.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Icon(
              SolarIconsOutline.altArrowRight,
              size: AppIconSize.m,
              color: context.ext.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
