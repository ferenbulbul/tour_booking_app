import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';

/// Prediction returned by the Places Autocomplete API.
class PlaceAutocompletePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  const PlaceAutocompletePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  factory PlaceAutocompletePrediction.fromJson(Map<String, dynamic> j) {
    final sf = j['structured_formatting'] ?? {};
    return PlaceAutocompletePrediction(
      placeId: j['place_id'],
      description: j['description'],
      mainText: sf['main_text'] ?? j['description'],
      secondaryText: sf['secondary_text'],
    );
  }
}

/// Place details result including address components and coordinates.
class PlaceDetailsResult {
  final String? formattedAddress;
  final String? name;
  final double? lat;
  final double? lng;
  final List<dynamic> addressComponents;

  const PlaceDetailsResult({
    this.formattedAddress,
    this.name,
    this.lat,
    this.lng,
    this.addressComponents = const [],
  });
}

/// Reverse geocode result (address details from lat/lng).
class ReverseGeocodeResult {
  final String formattedAddress;
  final List<dynamic> addressComponents;

  const ReverseGeocodeResult({
    required this.formattedAddress,
    required this.addressComponents,
  });
}

/// A single route returned by the Directions API.
class DirectionsRoute {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;
  final String summary;

  const DirectionsRoute({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
    required this.summary,
  });
}

class GooglePlaceService {
  static final _apiKey = Keys.places;

  /// Timeout for Google API requests
  static const Duration _timeout = Duration(seconds: 5);

  /// In-memory cache for repeated city+district lookups
  final Map<String, PlaceSelection> _cache = {};

  /// Finds default location for city + district automatically.
  /// Gets both address and coordinates with a single Geocoding API call.
  Future<PlaceSelection?> findDefaultPlace(String city, String district) async {
    final query = "$city $district";
    final cached = _cache[query];
    if (cached != null) return cached;

    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': query, 'key': _apiKey, 'language': 'tr'},
      );

      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK') return null;

      final results = body['results'] as List;
      if (results.isEmpty) return null;

      final first = results.first;
      final description = first['formatted_address'] as String? ?? query;
      final loc = first['geometry']?['location'];
      final lat = (loc?['lat'] as num?)?.toDouble();
      final lng = (loc?['lng'] as num?)?.toDouble();

      if (lat == null || lng == null) return null;

      final result = PlaceSelection(description: description, lat: lat, lng: lng);
      _cache[query] = result;
      return result;
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Places Autocomplete
  // -------------------------------------------------------------------

  /// Fetches autocomplete predictions for [input].
  /// Optionally biased by [location] and [radiusMeters].
  /// [components] filters by country (e.g. 'country:tr').
  Future<List<PlaceAutocompletePrediction>> autocomplete({
    required String input,
    String language = 'tr',
    String? components,
    LatLng? location,
    int? radiusMeters,
    bool strictBounds = false,
  }) async {
    try {
      final params = <String, String>{
        'input': input,
        'key': _apiKey,
        'language': language,
      };
      if (components != null) params['components'] = components;
      if (location != null) {
        params['location'] = '${location.latitude},${location.longitude}';
        params['radius'] = '${radiusMeters ?? 50000}';
        if (strictBounds) params['strictbounds'] = 'true';
      }

      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/autocomplete/json',
        params,
      );

      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) return [];

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK') return [];

      return (body['predictions'] as List)
          .map((e) => PlaceAutocompletePrediction.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // -------------------------------------------------------------------
  // Place Details
  // -------------------------------------------------------------------

  /// Fetches place details for [placeId].
  /// [fields] defaults to address, name, geometry, and address_components.
  Future<PlaceDetailsResult?> placeDetails({
    required String placeId,
    String language = 'tr',
    String fields = 'formatted_address,name,geometry/location,address_components',
  }) async {
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/details/json',
        {
          'place_id': placeId,
          'key': _apiKey,
          'language': language,
          'fields': fields,
        },
      );

      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK') return null;

      final result = body['result'];
      final loc = result['geometry']?['location'];

      return PlaceDetailsResult(
        formattedAddress: result['formatted_address'],
        name: result['name'],
        lat: (loc?['lat'] as num?)?.toDouble(),
        lng: (loc?['lng'] as num?)?.toDouble(),
        addressComponents: result['address_components'] ?? [],
      );
    } catch (e) {
      return null;
    }
  }

  /// Fetches only geometry for [placeId] (lighter call for transport search).
  Future<PlaceResult?> placeGeometry({required String placeId}) async {
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/details/json',
        {
          'place_id': placeId,
          'key': _apiKey,
          'fields': 'geometry',
        },
      );

      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK') return null;

      final loc = body['result']['geometry']['location'];
      return PlaceResult(
        lat: loc['lat'],
        lng: loc['lng'],
        address: '',
      );
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Reverse Geocoding
  // -------------------------------------------------------------------

  /// Returns address details for a given [lat]/[lng].
  Future<ReverseGeocodeResult?> reverseGeocode({
    required double lat,
    required double lng,
    String language = 'tr',
  }) async {
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {
          'latlng': '$lat,$lng',
          'key': _apiKey,
          'language': language,
        },
      );

      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final body = jsonDecode(res.body);
      if (body['status'] != 'OK') return null;

      final first = body['results'][0];
      return ReverseGeocodeResult(
        formattedAddress: first['formatted_address'] ?? '',
        addressComponents: first['address_components'] ?? [],
      );
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Directions
  // -------------------------------------------------------------------

  /// Fetches driving routes between [origin] and [destination].
  /// Returns multiple alternative routes when available.
  Future<List<DirectionsRoute>> fetchDirections({
    required LatLng origin,
    required LatLng destination,
    bool alternatives = true,
  }) async {
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving'
        '&alternatives=$alternatives'
        '&key=$_apiKey',
      );

      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return [];

      final routesJson = data['routes'] as List<dynamic>;
      final parsed = <DirectionsRoute>[];

      for (final route in routesJson) {
        final leg = (route['legs'] as List<dynamic>)[0];
        final distanceValue = (leg['distance']['value'] as num).toDouble();
        final durationValue = (leg['duration']['value'] as num).toInt();
        final distanceText = leg['distance']['text'] as String;
        final durationText = leg['duration']['text'] as String;
        final summary = (route['summary'] as String?) ?? '';

        final encodedPolyline =
            route['overview_polyline']['points'] as String;
        final rawPoints = _decodePolyline(encodedPolyline);
        final points = _simplifyPolyline(rawPoints, 0.0005);

        parsed.add(DirectionsRoute(
          points: points,
          distanceKm: distanceValue / 1000.0,
          durationMinutes: (durationValue / 60.0).round(),
          distanceText: distanceText,
          durationText: durationText,
          summary: summary,
        ));
      }

      return parsed;
    } catch (e) {
      return [];
    }
  }

  /// Simplifies a polyline using the Ramer-Douglas-Peucker algorithm.
  /// [tolerance] is in degrees (~0.0005 ≈ 55m).
  static List<LatLng> _simplifyPolyline(List<LatLng> points, double tolerance) {
    if (points.length <= 2) return points;

    double maxDist = 0;
    int maxIndex = 0;
    final start = points.first;
    final end = points.last;

    for (int i = 1; i < points.length - 1; i++) {
      final d = _perpendicularDist(points[i], start, end);
      if (d > maxDist) {
        maxDist = d;
        maxIndex = i;
      }
    }

    if (maxDist > tolerance * tolerance) {
      final left = _simplifyPolyline(points.sublist(0, maxIndex + 1), tolerance);
      final right = _simplifyPolyline(points.sublist(maxIndex), tolerance);
      return [...left.sublist(0, left.length - 1), ...right];
    }
    return [start, end];
  }

  static double _perpendicularDist(LatLng p, LatLng a, LatLng b) {
    final dx = b.longitude - a.longitude;
    final dy = b.latitude - a.latitude;
    if (dx == 0 && dy == 0) {
      final px = p.longitude - a.longitude;
      final py = p.latitude - a.latitude;
      return (px * px + py * py);
    }
    final t = ((p.longitude - a.longitude) * dx + (p.latitude - a.latitude) * dy) /
        (dx * dx + dy * dy);
    final ct = t.clamp(0.0, 1.0);
    final px = p.longitude - (a.longitude + ct * dx);
    final py = p.latitude - (a.latitude + ct * dy);
    return (px * px + py * py);
  }

  /// Decodes a Google encoded polyline string into a list of [LatLng].
  static List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
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
}
