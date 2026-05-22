import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class TransportSearchViewModel extends BaseViewModel {
  final GooglePlaceService _placeService =
      ServiceLocator.instance.googlePlaceService;

  List<PlacePrediction> predictions = [];

  /// Fetches autocomplete predictions for transport location search.
  Future<void> fetchPredictions({
    required String input,
    required String apiKey,
    LatLng? cityCenter,
  }) async {
    final results = await _placeService.autocomplete(
      input: input,
      components: 'country:tr',
      location: cityCenter,
      radiusMeters: 50000,
    );

    predictions = results
        .map((e) => PlacePrediction(
              placeId: e.placeId,
              description: e.description,
              mainText: e.mainText,
              secondaryText: e.secondaryText,
            ))
        .toList();
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
