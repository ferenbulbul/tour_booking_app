import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class TransportSearchViewModel extends BaseViewModel {
  final GooglePlaceService _placeService =
      ServiceLocator.instance.googlePlaceService;

  List<PlacePrediction> predictions = [];
  bool initialLoaded = false;

  /// Fetches autocomplete predictions for transport location search.
  ///
  /// [cityName] → pickup mode: prepends city name, strict bounds, 30km radius.
  /// [initialCityQuery] → dropoff initial: prepends city name for first load
  ///   but no strict bounds (user can type anything afterwards).
  Future<void> fetchPredictions({
    required String input,
    required String apiKey,
    LatLng? cityCenter,
    String? cityName,
    String? initialCityQuery,
  }) async {
    final String query;
    final bool strict;
    final int radius;

    if (cityName != null) {
      // Pickup: always prepend city + strict bounds
      query = '$cityName $input'.trim();
      strict = true;
      radius = 30000;
    } else if (initialCityQuery != null && input.isEmpty) {
      // Dropoff initial load: search with city name, no restriction
      query = initialCityQuery;
      strict = false;
      radius = 50000;
    } else {
      // Dropoff with user input: free search, biased to city center
      query = input;
      strict = false;
      radius = 50000;
    }

    final results = await _placeService.autocomplete(
      input: query,
      components: 'country:tr',
      location: cityCenter,
      radiusMeters: radius,
      strictBounds: strict,
    );

    predictions = results
        .map((e) => PlacePrediction(
              placeId: e.placeId,
              description: e.description,
              mainText: e.mainText,
              secondaryText: e.secondaryText,
            ))
        .toList();
    initialLoaded = true;
    notifyListeners();
  }

  /// Selects a place and fetches its geometry. Returns a [PlaceResult] or null.
  Future<PlaceResult?> selectPlace(PlacePrediction prediction) async {
    final geo = await _placeService.placeGeometry(
      placeId: prediction.placeId,
    );
    if (geo == null) return null;

    return PlaceResult(
      lat: geo.lat,
      lng: geo.lng,
      address: prediction.description,
    );
  }

  void clearPredictions() {
    predictions = [];
    notifyListeners();
  }
}
