import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceResult {
  final double lat;
  final double lng;
  final String address;
  const PlaceResult(
      {required this.lat, required this.lng, required this.address});
}

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> j) {
    final sf = j['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: j['place_id'],
      description: j['description'],
      mainText: sf['main_text'] ?? j['description'],
      secondaryText: sf['secondary_text'],
    );
  }
}

class ParsedRoute {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;
  final String summary;
  final String encodedPolyline;

  const ParsedRoute({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
    required this.summary,
    required this.encodedPolyline,
  });
}
