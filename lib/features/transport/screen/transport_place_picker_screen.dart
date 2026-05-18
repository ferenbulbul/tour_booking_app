import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/features/transport/screen/transport_search_sheet.dart';
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class TransportPlacePickerScreen extends StatefulWidget {
  final double? pickupLat;
  final double? pickupLng;
  final String? pickupAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? dropoffAddress;
  final bool initialModePickup;
  final String? cityName;

  const TransportPlacePickerScreen({
    super.key,
    this.pickupLat,
    this.pickupLng,
    this.pickupAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.dropoffAddress,
    this.initialModePickup = true,
    this.cityName,
  });

  @override
  State<TransportPlacePickerScreen> createState() =>
      _TransportPlacePickerScreenState();
}

class _TransportPlacePickerScreenState
    extends State<TransportPlacePickerScreen> {
  final _apiKey = Keys.places;

  bool _isPickupMode = true;
  GoogleMapController? _mapController;

  LatLng? _pickupPos;
  String? _pickupAddr;
  LatLng? _dropoffPos;
  String? _dropoffAddr;

  // City center for pickup bias
  LatLng? _cityCenter;

  // Routes
  List<ParsedRoute> _routes = [];
  int _selectedRouteIndex = 0;
  bool _routesLoading = false;

  bool get _bothSet => _pickupPos != null && _dropoffPos != null;

  @override
  void initState() {
    super.initState();
    _isPickupMode = widget.initialModePickup;

    if (widget.pickupLat != null && widget.pickupLng != null) {
      _pickupPos = LatLng(widget.pickupLat!, widget.pickupLng!);
      _pickupAddr = widget.pickupAddress;
    }
    if (widget.dropoffLat != null && widget.dropoffLng != null) {
      _dropoffPos = LatLng(widget.dropoffLat!, widget.dropoffLng!);
      _dropoffAddr = widget.dropoffAddress;
    }

    if (_bothSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRoutes());
    }
  }

  // ---------------------------------------------------------------
  // CAMERA / CITY
  // ---------------------------------------------------------------
  LatLng get _initialCameraPos {
    if (_pickupPos != null) return _pickupPos!;
    if (_dropoffPos != null) return _dropoffPos!;
    return const LatLng(41.0082, 28.9784);
  }

  double get _initialZoom {
    if (_bothSet) return 11;
    if (_pickupPos != null || _dropoffPos != null) return 13;
    return 11;
  }

  Future<void> _geocodeCity() async {
    if (widget.cityName == null || widget.cityName!.isEmpty) return;

    final uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent('${widget.cityName}, Türkiye')}'
      '&key=$_apiKey&language=tr',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200 && mounted) {
        final body = jsonDecode(res.body);
        if (body['status'] == 'OK' && (body['results'] as List).isNotEmpty) {
          final loc = body['results'][0]['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          _cityCenter = LatLng(lat, lng);

          if (_pickupPos == null && _dropoffPos == null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(LatLng(lat, lng), 12),
            );
          }
        }
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------
  // MARKERS
  // ---------------------------------------------------------------
  Set<Marker> get _markers {
    final m = <Marker>{};
    if (_pickupPos != null) {
      m.add(Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupPos!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        draggable: true,
        onDragEnd: (pos) => _setPickup(pos, null, reverseGeocode: true),
      ));
    }
    if (_dropoffPos != null) {
      m.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffPos!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        draggable: true,
        onDragEnd: (pos) => _setDropoff(pos, null, reverseGeocode: true),
      ));
    }
    return m;
  }

  // ---------------------------------------------------------------
  // POLYLINES
  // ---------------------------------------------------------------
  Set<Polyline> get _polylines {
    if (_routes.isEmpty) return {};
    final polylines = <Polyline>{};

    for (int i = 0; i < _routes.length; i++) {
      if (i == _selectedRouteIndex) continue;
      polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: _routes[i].points,
        color: Colors.grey.shade400,
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        consumeTapEvents: true,
        onTap: () => _selectRoute(i),
      ));
    }

    polylines.add(Polyline(
      polylineId: PolylineId('route_selected_$_selectedRouteIndex'),
      points: _routes[_selectedRouteIndex].points,
      color: AppColors.primary,
      width: 5,
    ));

    return polylines;
  }

  void _selectRoute(int index) {
    if (index == _selectedRouteIndex) return;
    setState(() => _selectedRouteIndex = index);
  }

  // ---------------------------------------------------------------
  // FETCH ROUTES
  // ---------------------------------------------------------------
  Future<void> _fetchRoutes() async {
    if (!_bothSet) return;

    setState(() {
      _routesLoading = true;
      _routes = [];
      _selectedRouteIndex = 0;
    });

    try {
      final origin = '${_pickupPos!.latitude},${_pickupPos!.longitude}';
      final dest = '${_dropoffPos!.latitude},${_dropoffPos!.longitude}';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$origin&destination=$dest'
        '&mode=driving&alternatives=true'
        '&key=$_apiKey',
      );

      final response = await http.get(url);
      if (response.statusCode != 200 || !mounted) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return;

      final routesJson = data['routes'] as List<dynamic>;
      final parsed = <ParsedRoute>[];

      for (final route in routesJson) {
        final leg = (route['legs'] as List<dynamic>)[0];
        parsed.add(ParsedRoute(
          points: _decodePolyline(
              route['overview_polyline']['points'] as String),
          distanceKm:
              (leg['distance']['value'] as num).toDouble() / 1000.0,
          durationMinutes:
              ((leg['duration']['value'] as num).toInt() / 60.0).round(),
          distanceText: leg['distance']['text'] as String,
          durationText: leg['duration']['text'] as String,
          summary: (route['summary'] as String?) ?? '',
        ));
      }

      if (parsed.isNotEmpty && mounted) {
        setState(() {
          _routes = parsed;
          _selectedRouteIndex = 0;
        });
        _fitBounds();
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _routesLoading = false);
    }
  }

  // ---------------------------------------------------------------
  // SET LOCATIONS
  // ---------------------------------------------------------------
  void _setPickup(LatLng pos, String? address, {bool reverseGeocode = false}) {
    setState(() {
      _pickupPos = pos;
      _pickupAddr = address;
      _routes = [];
      _selectedRouteIndex = 0;
    });

    if (reverseGeocode) _reverseGeocodeWithValidation(pos, true);

    if (_dropoffPos == null) {
      setState(() => _isPickupMode = false);
      _animateCamera(pos);
    } else {
      _fetchRoutes();
    }
  }

  void _setDropoff(LatLng pos, String? address, {bool reverseGeocode = false}) {
    setState(() {
      _dropoffPos = pos;
      _dropoffAddr = address;
      _routes = [];
      _selectedRouteIndex = 0;
    });

    if (reverseGeocode) _reverseGeocodeWithValidation(pos, false);

    if (_pickupPos == null) {
      _animateCamera(pos);
    } else {
      _fetchRoutes();
    }
  }

  void _animateCamera(LatLng pos) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
  }

  void _fitBounds() {
    if (!_bothSet || _mapController == null) return;
    final south = min(_pickupPos!.latitude, _dropoffPos!.latitude);
    final north = max(_pickupPos!.latitude, _dropoffPos!.latitude);
    final west = min(_pickupPos!.longitude, _dropoffPos!.longitude);
    final east = max(_pickupPos!.longitude, _dropoffPos!.longitude);

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(south, west),
        northeast: LatLng(north, east),
      ),
      80,
    ));
  }

  // ---------------------------------------------------------------
  // MAP TAP
  // ---------------------------------------------------------------
  void _onMapTap(LatLng pos) {
    if (_isPickupMode) {
      _setPickup(pos, null, reverseGeocode: true);
    } else {
      _setDropoff(pos, null, reverseGeocode: true);
    }
  }

  // ---------------------------------------------------------------
  // REVERSE GEOCODE + CITY VALIDATION
  // ---------------------------------------------------------------
  Future<void> _reverseGeocodeWithValidation(
      LatLng pos, bool isPickup) async {
    final uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=${pos.latitude},${pos.longitude}'
      '&key=$_apiKey&language=tr',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode != 200 || !mounted) return;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK' ||
          (body['results'] as List).isEmpty) {
        return;
      }

      final firstResult = body['results'][0];
      final addr = firstResult['formatted_address'] ?? '';

      // Validate pickup city
      if (isPickup && widget.cityName != null) {
        final components =
            firstResult['address_components'] as List<dynamic>;
        final cityLower = widget.cityName!.toLowerCase();
        final inCity = components.any((c) {
          final types = (c['types'] as List).cast<String>();
          final name = (c['long_name'] as String).toLowerCase();
          return (types.contains('administrative_area_level_1') ||
                  types.contains('locality')) &&
              name.contains(cityLower);
        });

        if (!inCity) {
          setState(() {
            _pickupPos = null;
            _pickupAddr = null;
            _routes = [];
          });
          if (mounted) {
            UIHelper.showError(context, 'Kalkış noktası ${widget.cityName} içinde olmalıdır');
          }
          return;
        }
      }

      setState(() {
        if (isPickup) {
          _pickupAddr = addr;
        } else {
          _dropoffAddr = addr;
        }
      });
    } catch (_) {}
  }

  // ---------------------------------------------------------------
  // SEARCH SHEET (bottom)
  // ---------------------------------------------------------------
  Future<void> _openSearchSheet(bool forPickup) async {
    setState(() => _isPickupMode = forPickup);

    final result = await showModalBottomSheet<PlaceResult>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransportSearchSheet(
        apiKey: _apiKey,
        cityBias: forPickup ? widget.cityName : null,
        cityCenter: forPickup ? _cityCenter : null,
        cityName: forPickup ? widget.cityName : null,
        hintText: forPickup ? 'Kalkış noktası ara...' : 'Varış noktası ara...',
        iconColor: forPickup ? Colors.green : Colors.red,
      ),
    );

    if (result != null && mounted) {
      if (forPickup) {
        _setPickup(LatLng(result.lat, result.lng), result.address);
      } else {
        _setDropoff(LatLng(result.lat, result.lng), result.address);
      }
    }
  }

  // ---------------------------------------------------------------
  // SWAP
  // ---------------------------------------------------------------
  void _swapLocations() {
    final tempPos = _pickupPos;
    final tempAddr = _pickupAddr;
    setState(() {
      _pickupPos = _dropoffPos;
      _pickupAddr = _dropoffAddr;
      _dropoffPos = tempPos;
      _dropoffAddr = tempAddr;
      _routes = [];
      _selectedRouteIndex = 0;
    });
    if (_bothSet) _fetchRoutes();
  }

  // ---------------------------------------------------------------
  // CONFIRM
  // ---------------------------------------------------------------
  void _confirm() {
    final selectedRoute = _routes.isNotEmpty ? _routes[_selectedRouteIndex] : null;
    Navigator.pop(
      context,
      TransportLocationsResult(
        pickup: _pickupPos != null
            ? PlaceSelection(
                description: _pickupAddr ?? '',
                lat: _pickupPos!.latitude,
                lng: _pickupPos!.longitude,
              )
            : null,
        dropoff: _dropoffPos != null
            ? PlaceSelection(
                description: _dropoffAddr ?? '',
                lat: _dropoffPos!.latitude,
                lng: _dropoffPos!.longitude,
              )
            : null,
        distanceKm: selectedRoute?.distanceKm,
        durationMinutes: selectedRoute?.durationMinutes,
      ),
    );
  }

  // ---------------------------------------------------------------
  // DECODE POLYLINE
  // ---------------------------------------------------------------
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0, lat = 0, lng = 0;
    while (index < encoded.length) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // ---------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final bottomH = _routes.length > 1 ? 310.0 : 240.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ---- MAP ----
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialCameraPos,
              zoom: _initialZoom,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (c) {
              _mapController = c;
              _geocodeCity();
              if (_bothSet && _routes.isEmpty) {
                Future.delayed(
                    const Duration(milliseconds: 500), _fitBounds);
              }
            },
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            padding: EdgeInsets.only(top: 80, bottom: bottomH),
          ),

          // ---- ROUTES LOADING ----
          if (_routesLoading)
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Rota hesaplanıyor...',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // ---- TOP: Back + Mode toggle ----
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _circleButton(
                      Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildModeToggle()),
                ],
              ),
            ),
          ),

          // ---- BOTTOM CARD ----
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location slots + Swap
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _locationSlot(
                                color: Colors.green,
                                address: _pickupAddr,
                                placeholder: 'Kalkış noktası ara...',
                                isActive: _isPickupMode,
                                onTap: () => _openSearchSheet(true),
                                onClear: () => setState(() {
                                  _pickupPos = null;
                                  _pickupAddr = null;
                                  _routes = [];
                                  _selectedRouteIndex = 0;
                                }),
                              ),
                              const SizedBox(height: 14),
                              _locationSlot(
                                color: Colors.red,
                                address: _dropoffAddr,
                                placeholder: 'Varış noktası ara...',
                                isActive: !_isPickupMode,
                                onTap: () => _openSearchSheet(false),
                                onClear: () => setState(() {
                                  _dropoffPos = null;
                                  _dropoffAddr = null;
                                  _routes = [];
                                  _selectedRouteIndex = 0;
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: (_pickupPos != null ||
                                  _dropoffPos != null)
                              ? _swapLocations
                              : null,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.accent
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(SolarIconsOutline.roundArrowLeftDown,
                                size: 20, color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),

                    // Route cards
                    if (_routes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _routes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => _routeCard(_routes[i], i),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    PrimaryButton(
                      text: 'Devam Et',
                      icon: SolarIconsOutline.altArrowRight,
                      onPressed: _bothSet ? _confirm : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // WIDGETS
  // ---------------------------------------------------------------
  Widget _routeCard(ParsedRoute route, int index) {
    final isSelected = index == _selectedRouteIndex;
    return GestureDetector(
      onTap: () => _selectRoute(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              route.summary.isNotEmpty
                  ? route.summary
                  : 'Rota ${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${route.distanceText} \u2022 ${route.durationText}',
              style: TextStyle(
                fontSize: 11,
                color:
                    isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          _modeTab('Kalkış', Colors.green, _isPickupMode,
              () => setState(() => _isPickupMode = true)),
          _modeTab('Varış', Colors.red, !_isPickupMode,
              () => setState(() => _isPickupMode = false)),
        ],
      ),
    );
  }

  Widget _modeTab(
      String label, Color color, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle,
                  size: 10, color: isActive ? Colors.white : color),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        isActive ? Colors.white : AppColors.textPrimary,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationSlot({
    required Color color,
    required String? address,
    required String placeholder,
    required bool isActive,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final hasAddr = address != null && address.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.5)
                : AppColors.border,
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, size: 10, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasAddr ? address : placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      hasAddr ? FontWeight.w600 : FontWeight.w400,
                  color: hasAddr
                      ? AppColors.textPrimary
                      : AppColors.textLight,
                ),
              ),
            ),
            if (hasAddr)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClear,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(SolarIconsOutline.closeCircle,
                      size: 16, color: AppColors.textLight),
                ),
              )
            else
              Icon(SolarIconsOutline.magnifier, size: 18, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
