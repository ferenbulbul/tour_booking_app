import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class PlacePickerViewModel extends BaseViewModel {
  final GooglePlaceService _placeService =
      ServiceLocator.instance.googlePlaceService;

  final String city;
  final String district;

  PlacePickerViewModel({required this.city, required this.district});

  bool isLoading = false;
  List<PlaceAutocompletePrediction> predictions = [];
  String? errorMessage;

  /// Searches for place predictions given a [query].
  Future<void> search(String query) async {
    final q = "$city $district $query".trim();
    isLoading = true;
    notifyListeners();

    final results = await _placeService.autocomplete(input: q);

    predictions = results;
    isLoading = false;
    notifyListeners();
  }

  /// Picks a prediction and returns a [PlaceSelection] if valid, or sets
  /// [errorMessage] if the location is outside the expected city/district.
  Future<PlaceSelection?> pick(PlaceAutocompletePrediction prediction) async {
    errorMessage = null;

    final details = await _placeService.placeDetails(
      placeId: prediction.placeId,
    );
    if (details == null) return null;

    final validation = LocationValidator.validate(
      components: details.addressComponents,
      formatted: details.formattedAddress ?? '',
      expectedCity: city,
      expectedDistrict: district,
    );

    if (!validation.isValid) {
      errorMessage = validation.errorMessage;
      notifyListeners();
      return null;
    }

    if (details.lat == null || details.lng == null) {
      return null;
    }

    return PlaceSelection(
      description: prediction.description,
      lat: details.lat,
      lng: details.lng,
    );
  }
}
