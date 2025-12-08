import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_booking/keys.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class GooglePlaceService {
  static final _apiKey = Keys.places;

  /// Şehir + ilçe için otomatik default konum bulan fonksiyon
  Future<PlaceSelection?> findDefaultPlace(String city, String district) async {
    try {
      final query = "$city $district";

      // AUTOCOMPLETE
      final autoUri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/autocomplete/json',
        {'input': query, 'key': _apiKey, 'language': 'tr'},
      );

      final autoRes = await http.get(autoUri);
      if (autoRes.statusCode != 200) return null;

      final autoBody = jsonDecode(autoRes.body);
      if (autoBody['status'] != 'OK') return null;

      final predictions = autoBody['predictions'] as List;
      if (predictions.isEmpty) return null;

      final placeId = predictions.first['place_id'];
      final description = predictions.first['description'];

      // PLACE DETAILS
      final detailUri =
          Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
            'place_id': placeId,
            'key': _apiKey,
            'language': 'tr',
            'fields': 'formatted_address,geometry/location',
          });

      final detailRes = await http.get(detailUri);
      if (detailRes.statusCode != 200) return null;

      final detailBody = jsonDecode(detailRes.body);
      if (detailBody['status'] != 'OK') return null;

      final loc = detailBody['result']['geometry']?['location'];
      final lat = (loc?['lat'] as num?)?.toDouble();
      final lng = (loc?['lng'] as num?)?.toDouble();

      if (lat == null || lng == null) return null;

      return PlaceSelection(description: description, lat: lat, lng: lng);
    } catch (_) {
      return null;
    }
  }
}
