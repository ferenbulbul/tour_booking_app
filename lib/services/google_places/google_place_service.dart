import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class GooglePlaceService {
  static final _apiKey = Keys.places;

  /// Timeout for Google API requests
  static const Duration _timeout = Duration(seconds: 5);

  /// In-memory cache for repeated city+district lookups
  final Map<String, PlaceSelection> _cache = {};

  /// Şehir + ilçe için otomatik default konum bulan fonksiyon
  /// Tek bir Geocoding API çağrısı ile hem adres hem koordinat alınır.
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
    } catch (_) {
      return null;
    }
  }
}
