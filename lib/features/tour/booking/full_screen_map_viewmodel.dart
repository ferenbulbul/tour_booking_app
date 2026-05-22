import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/core/utils/location_validator.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

/// Result of a reverse geocode tap validation.
class MapTapResult {
  final bool isValid;
  final String? formattedAddress;
  final double lat;
  final double lng;
  final String? errorMessage;

  const MapTapResult({
    required this.isValid,
    this.formattedAddress,
    required this.lat,
    required this.lng,
    this.errorMessage,
  });
}

class FullScreenMapViewModel extends BaseViewModel {
  final GooglePlaceService _placeService =
      ServiceLocator.instance.googlePlaceService;

  String? selectedAddress;
  String? warningMessage;

  /// Reverse geocodes the tapped position and validates it against
  /// the expected [city] and [district].
  Future<MapTapResult?> validateTap({
    required double lat,
    required double lng,
    required String expectedCity,
    required String expectedDistrict,
  }) async {
    final result = await _placeService.reverseGeocode(lat: lat, lng: lng);
    if (result == null) return null;

    final validation = LocationValidator.validate(
      components: result.addressComponents,
      formatted: result.formattedAddress,
      expectedCity: expectedCity,
      expectedDistrict: expectedDistrict,
    );

    if (!validation.isValid) {
      warningMessage = validation.errorMessage;
      notifyListeners();
      return MapTapResult(
        isValid: false,
        lat: lat,
        lng: lng,
        errorMessage: validation.errorMessage,
      );
    }

    selectedAddress = result.formattedAddress;
    warningMessage = null;
    notifyListeners();

    return MapTapResult(
      isValid: true,
      formattedAddress: result.formattedAddress,
      lat: lat,
      lng: lng,
    );
  }

  void clearWarning() {
    warningMessage = null;
    notifyListeners();
  }
}
