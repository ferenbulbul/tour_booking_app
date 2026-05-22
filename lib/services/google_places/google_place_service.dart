import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      debugPrint('GooglePlaceService.findDefaultPlace: $e');
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
      debugPrint('GooglePlaceService.autocomplete: $e');
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
      debugPrint('GooglePlaceService.placeDetails: $e');
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
      debugPrint('GooglePlaceService.placeGeometry: $e');
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
      debugPrint('GooglePlaceService.reverseGeocode: $e');
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
        final points = _decodePolyline(encodedPolyline);

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
      debugPrint('GooglePlaceService.fetchDirections: $e');
      return [];
    }
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
