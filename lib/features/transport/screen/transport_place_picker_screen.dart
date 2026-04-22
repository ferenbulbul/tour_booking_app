import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

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
  List<_ParsedRoute> _routes = [];
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
      final parsed = <_ParsedRoute>[];

      for (final route in routesJson) {
        final leg = (route['legs'] as List<dynamic>)[0];
        parsed.add(_ParsedRoute(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Kalkış noktası ${widget.cityName} içinde olmalıdır'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
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

    final result = await showModalBottomSheet<_PlaceResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchSheet(
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
                      Icons.arrow_back, () => Navigator.pop(context)),
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
                              color: AppColors.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.swap_vert,
                                size: 20, color: AppColors.primary),
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
                      icon: Icons.arrow_forward,
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
  Widget _routeCard(_ParsedRoute route, int index) {
    final isSelected = index == _selectedRouteIndex;
    return GestureDetector(
      onTap: () => _selectRoute(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
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
                  child: Icon(Icons.close,
                      size: 16, color: AppColors.textLight),
                ),
              )
            else
              Icon(Icons.search, size: 18, color: AppColors.textLight),
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

// =================================================================
// SEARCH BOTTOM SHEET
// =================================================================
class _SearchSheet extends StatefulWidget {
  final String apiKey;
  final String? cityBias;
  final LatLng? cityCenter;
  final String? cityName;
  final String hintText;
  final Color iconColor;

  const _SearchSheet({
    required this.apiKey,
    this.cityBias,
    this.cityCenter,
    this.cityName,
    required this.hintText,
    required this.iconColor,
  });

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<_Prediction> _predictions = [];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    setState(() => _loading = true);

    final params = <String, String>{
      'input': query,
      'key': widget.apiKey,
      'language': 'tr',
      'components': 'country:tr',
    };

    if (widget.cityCenter != null) {
      params['location'] =
          '${widget.cityCenter!.latitude},${widget.cityCenter!.longitude}';
      params['radius'] = '50000';
      params['strictbounds'] = 'true';
    }

    final uri = Uri.https(
        'maps.googleapis.com', '/maps/api/place/autocomplete/json', params);

    try {
      final res = await http.get(uri);
      if (!mounted) return;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == 'OK') {
          var list = (body['predictions'] as List)
              .map((e) => _Prediction.fromJson(e))
              .toList();

          // Filter results to only show places within the city
          if (widget.cityName != null) {
            final cityLower = widget.cityName!.toLowerCase();
            list = list
                .where((p) =>
                    p.description.toLowerCase().contains(cityLower))
                .toList();
          }

          setState(() => _predictions = list);
        } else {
          setState(() => _predictions = []);
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _selectPrediction(_Prediction p) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': p.placeId,
        'key': widget.apiKey,
        'language': 'tr',
        'fields': 'formatted_address,geometry/location,address_components',
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200 || !mounted) return;

    final body = jsonDecode(res.body);
    if (body['status'] != 'OK') return;

    final result = body['result'];
    final loc = result['geometry']?['location'];
    final lat = (loc?['lat'] as num?)?.toDouble();
    final lng = (loc?['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return;

    // Validate city restriction for pickup
    if (widget.cityName != null) {
      final components =
          (result['address_components'] as List<dynamic>?) ?? [];
      final cityLower = widget.cityName!.toLowerCase();
      final inCity = components.any((c) {
        final types = (c['types'] as List).cast<String>();
        final name = (c['long_name'] as String).toLowerCase();
        return (types.contains('administrative_area_level_1') ||
                types.contains('locality')) &&
            name.contains(cityLower);
      });

      if (!inCity && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Kalkış noktası ${widget.cityName} içinde olmalıdır'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    final address = result['formatted_address'] ?? p.description;

    if (mounted) {
      Navigator.pop(
          context, _PlaceResult(lat: lat, lng: lng, address: address));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Search field
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  onChanged: _onChanged,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        size: 22, color: widget.iconColor),
                    suffixIcon: _ctrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _ctrl.clear();
                              setState(() => _predictions = []);
                            },
                          )
                        : null,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: AppColors.textLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: widget.iconColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              if (_loading)
                LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor:
                      AppColors.primary.withValues(alpha: 0.2),
                ),

              // Results
              Expanded(
                child: _predictions.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            _ctrl.text.isEmpty
                                ? 'Aramak için yazmaya başlayın'
                                : 'Sonuç bulunamadı',
                            style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _predictions.length,
                        separatorBuilder: (_, __) => Divider(
                            height: 1, color: Colors.grey.shade200),
                        itemBuilder: (_, i) {
                          final p = _predictions[i];
                          return ListTile(
                            leading: Icon(Icons.location_on_outlined,
                                color: widget.iconColor),
                            title: Text(p.mainText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: p.secondaryText != null
                                ? Text(p.secondaryText!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600))
                                : null,
                            onTap: () => _selectPrediction(p),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =================================================================
// PRIVATE MODELS
// =================================================================
class _PlaceResult {
  final double lat;
  final double lng;
  final String address;
  const _PlaceResult(
      {required this.lat, required this.lng, required this.address});
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
    final sf = j['structured_formatting'] ?? {};
    return _Prediction(
      placeId: j['place_id'],
      description: j['description'],
      mainText: sf['main_text'] ?? j['description'],
      secondaryText: sf['secondary_text'],
    );
  }
}

class _ParsedRoute {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;
  final String summary;

  const _ParsedRoute({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
    required this.summary,
  });
}
