import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';

/// Callback signatures the screen can provide so the ViewModel can request
/// UI-only actions (camera animation, error display) without holding
/// a BuildContext or GoogleMapController reference.
typedef OnCameraAnimateRequest = void Function(LatLng target, double zoom);
typedef OnFitBoundsRequest = void Function();
typedef OnCityValidationError = void Function(String message);

class TransportPlacePickerViewModel extends BaseViewModel {
  TransportPlacePickerViewModel({
    double? pickupLat,
    double? pickupLng,
    String? pickupAddress,
    double? dropoffLat,
    double? dropoffLng,
    String? dropoffAddress,
    bool initialModePickup = true,
    this.cityName,
    this.suggestedLocations = const [],
  }) {
    _isPickupMode = initialModePickup;

    if (pickupLat != null && pickupLng != null) {
      _pickupPos = LatLng(pickupLat, pickupLng);
      _pickupAddr = pickupAddress;
    }
    if (dropoffLat != null && dropoffLng != null) {
      _dropoffPos = LatLng(dropoffLat, dropoffLng);
      _dropoffAddr = dropoffAddress;
    }
  }

  // ---------------------------------------------------------------
  // API KEY
  // ---------------------------------------------------------------
  final String _apiKey = Keys.places;
  String get apiKey => _apiKey;

  // ---------------------------------------------------------------
  // CITY NAME & SUGGESTED LOCATIONS (constructor parameters, immutable)
  // ---------------------------------------------------------------
  final String? cityName;
  final List<TransportSuggestedLocation> suggestedLocations;

  // ---------------------------------------------------------------
  // CALLBACKS – set by the screen after construction
  // ---------------------------------------------------------------
  OnCameraAnimateRequest? onCameraAnimateRequest;
  OnFitBoundsRequest? onFitBoundsRequest;
  OnCityValidationError? onCityValidationError;

  // ---------------------------------------------------------------
  // LOCATION STATE
  // ---------------------------------------------------------------
  LatLng? _pickupPos;
  LatLng? get pickupPos => _pickupPos;

  LatLng? _dropoffPos;
  LatLng? get dropoffPos => _dropoffPos;

  String? _pickupAddr;
  String? get pickupAddr => _pickupAddr;

  String? _dropoffAddr;
  String? get dropoffAddr => _dropoffAddr;

  LatLng? _cityCenter;
  LatLng? get cityCenter => _cityCenter;

  bool _isPickupMode = true;
  bool get isPickupMode => _isPickupMode;

  set isPickupMode(bool value) {
    if (_isPickupMode == value) return;
    _isPickupMode = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // ROUTE STATE
  // ---------------------------------------------------------------
  List<ParsedRoute> _routes = [];
  List<ParsedRoute> get routes => _routes;

  int _selectedRouteIndex = 0;
  int get selectedRouteIndex => _selectedRouteIndex;

  String? _routeError;
  String? get routeError => _routeError;

  bool _routesLoading = false;
  bool get routesLoading => _routesLoading;

  // ---------------------------------------------------------------
  // COMPUTED PROPERTIES
  // ---------------------------------------------------------------
  bool get bothSet => _pickupPos != null && _dropoffPos != null;

  LatLng get initialCameraPos {
    if (_pickupPos != null) return _pickupPos!;
    if (_dropoffPos != null) return _dropoffPos!;
    return const LatLng(41.0082, 28.9784);
  }

  double get initialZoom {
    if (bothSet) return 11;
    if (_pickupPos != null || _dropoffPos != null) return 13;
    return 11;
  }

  /// Builds the marker set.
  ///
  /// [onPickupDragEnd] and [onDropoffDragEnd] are callbacks so the screen
  /// can trigger camera animations after a marker drag.
  Set<Marker> buildMarkers({
    required void Function(LatLng pos) onPickupDragEnd,
    required void Function(LatLng pos) onDropoffDragEnd,
  }) {
    final m = <Marker>{};
    if (_pickupPos != null) {
      m.add(Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupPos!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        draggable: true,
        onDragEnd: onPickupDragEnd,
      ));
    }
    if (_dropoffPos != null) {
      m.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffPos!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        draggable: true,
        onDragEnd: onDropoffDragEnd,
      ));
    }
    return m;
  }

  /// The result to return when the user confirms.
  TransportLocationsResult get confirmResult {
    final selectedRoute =
        _routes.isNotEmpty ? _routes[_selectedRouteIndex] : null;
    return TransportLocationsResult(
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
      routePolyline: selectedRoute?.encodedPolyline,
    );
  }

  // ---------------------------------------------------------------
  // GEOCODE CITY
  // ---------------------------------------------------------------
  Future<void> geocodeCity() async {
    if (cityName == null || cityName!.isEmpty) return;

    final uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent('$cityName, Türkiye')}'
      '&key=$_apiKey&language=tr',
    );

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == 'OK' && (body['results'] as List).isNotEmpty) {
          final loc = body['results'][0]['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          _cityCenter = LatLng(lat, lng);

          if (_pickupPos == null && _dropoffPos == null) {
            onCameraAnimateRequest?.call(LatLng(lat, lng), 12);
          }
        }
      }
    } catch (e) {
      // Non-critical: map just won't auto-center on the city
    }
  }

  // ---------------------------------------------------------------
  // SELECT ROUTE
  // ---------------------------------------------------------------
  void selectRoute(int index) {
    if (index == _selectedRouteIndex) return;
    _selectedRouteIndex = index;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // FETCH ROUTES
  // ---------------------------------------------------------------
  Future<void> fetchRoutes() async {
    if (!bothSet) return;

    _routesLoading = true;
    _routes = [];
    _selectedRouteIndex = 0;
    _routeError = null;
    notifyListeners();

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
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return;

      final routesJson = data['routes'] as List<dynamic>;
      final parsed = <ParsedRoute>[];

      for (final route in routesJson) {
        final leg = (route['legs'] as List<dynamic>)[0];
        final encodedPoly = route['overview_polyline']['points'] as String;
        parsed.add(ParsedRoute(
          points: simplifyPolyline(decodePolyline(encodedPoly), 0.0005),
          distanceKm: (leg['distance']['value'] as num).toDouble() / 1000.0,
          durationMinutes:
              ((leg['duration']['value'] as num).toInt() / 60.0).round(),
          distanceText: leg['distance']['text'] as String,
          durationText: leg['duration']['text'] as String,
          summary: (route['summary'] as String?) ?? '',
          encodedPolyline: encodedPoly,
        ));
      }

      if (parsed.isNotEmpty) {
        _routes = parsed;
        _selectedRouteIndex = 0;
        notifyListeners();
        onFitBoundsRequest?.call();
      }
    } catch (e) {
      _routeError = tr('error_generic');
    } finally {
      _routesLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------
  // SET LOCATIONS
  // ---------------------------------------------------------------
  void setPickup(LatLng pos, String? address, {bool reverseGeocode = false}) {
    _pickupPos = pos;
    _pickupAddr = address;
    _routes = [];
    _selectedRouteIndex = 0;
    notifyListeners();

    if (reverseGeocode) _reverseGeocodeWithValidation(pos, true);

    if (_dropoffPos == null) {
      _isPickupMode = false;
      notifyListeners();
      onCameraAnimateRequest?.call(pos, 15);
    } else {
      fetchRoutes();
    }
  }

  void setDropoff(LatLng pos, String? address, {bool reverseGeocode = false}) {
    _dropoffPos = pos;
    _dropoffAddr = address;
    _routes = [];
    _selectedRouteIndex = 0;
    notifyListeners();

    if (reverseGeocode) _reverseGeocodeWithValidation(pos, false);

    if (_pickupPos == null) {
      onCameraAnimateRequest?.call(pos, 15);
    } else {
      fetchRoutes();
    }
  }

  // ---------------------------------------------------------------
  // CLEAR LOCATIONS
  // ---------------------------------------------------------------
  void clearPickup() {
    _pickupPos = null;
    _pickupAddr = null;
    _routes = [];
    _selectedRouteIndex = 0;
    notifyListeners();
  }

  void clearDropoff() {
    _dropoffPos = null;
    _dropoffAddr = null;
    _routes = [];
    _selectedRouteIndex = 0;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // MAP TAP
  // ---------------------------------------------------------------
  void onMapTap(LatLng pos) {
    if (_isPickupMode) {
      setPickup(pos, null, reverseGeocode: true);
    } else {
      setDropoff(pos, null, reverseGeocode: true);
    }
  }

  // ---------------------------------------------------------------
  // SWAP
  // ---------------------------------------------------------------
  void swapLocations() {
    final tempPos = _pickupPos;
    final tempAddr = _pickupAddr;
    _pickupPos = _dropoffPos;
    _pickupAddr = _dropoffAddr;
    _dropoffPos = tempPos;
    _dropoffAddr = tempAddr;
    _routes = [];
    _selectedRouteIndex = 0;
    notifyListeners();

    if (bothSet) fetchRoutes();
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
      if (res.statusCode != 200) return;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK' || (body['results'] as List).isEmpty) {
        return;
      }

      final firstResult = body['results'][0];
      final addr = firstResult['formatted_address'] ?? '';

      // Validate pickup city
      if (isPickup && cityName != null) {
        final components =
            firstResult['address_components'] as List<dynamic>;
        final cityLower = cityName!.toLowerCase();
        final inCity = components.any((c) {
          final types = (c['types'] as List).cast<String>();
          final name = (c['long_name'] as String).toLowerCase();
          return (types.contains('administrative_area_level_1') ||
                  types.contains('locality')) &&
              name.contains(cityLower);
        });

        if (!inCity) {
          _pickupPos = null;
          _pickupAddr = null;
          _routes = [];
          notifyListeners();
          onCityValidationError?.call(
            tr('transport_pickup_must_be_in_city',
                namedArgs: {'city': cityName!}),
          );
          return;
        }
      }

      if (isPickup) {
        _pickupAddr = addr;
      } else {
        _dropoffAddr = addr;
      }
      notifyListeners();
    } catch (e) {
      // Address resolution failed — clear address so user retries
      if (isPickup) {
        _pickupAddr = null;
      } else {
        _dropoffAddr = null;
      }
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------
  // DECODE + SIMPLIFY POLYLINE
  // ---------------------------------------------------------------
  static List<LatLng> decodePolyline(String encoded) {
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

  /// Ramer-Douglas-Peucker polyline simplification.
  static List<LatLng> simplifyPolyline(List<LatLng> points, double tolerance) {
    if (points.length <= 2) return points;

    double maxDist = 0;
    int maxIndex = 0;
    final start = points.first;
    final end = points.last;

    for (int i = 1; i < points.length - 1; i++) {
      final dx = end.longitude - start.longitude;
      final dy = end.latitude - start.latitude;
      double d;
      if (dx == 0 && dy == 0) {
        final px = points[i].longitude - start.longitude;
        final py = points[i].latitude - start.latitude;
        d = px * px + py * py;
      } else {
        final t = ((points[i].longitude - start.longitude) * dx +
                    (points[i].latitude - start.latitude) * dy) /
                (dx * dx + dy * dy);
        final ct = t.clamp(0.0, 1.0);
        final px = points[i].longitude - (start.longitude + ct * dx);
        final py = points[i].latitude - (start.latitude + ct * dy);
        d = px * px + py * py;
      }
      if (d > maxDist) {
        maxDist = d;
        maxIndex = i;
      }
    }

    if (maxDist > tolerance * tolerance) {
      final left = simplifyPolyline(points.sublist(0, maxIndex + 1), tolerance);
      final right = simplifyPolyline(points.sublist(maxIndex), tolerance);
      return [...left.sublist(0, left.length - 1), ...right];
    }
    return [start, end];
  }
}
