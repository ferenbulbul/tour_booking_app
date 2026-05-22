import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class TransportRouteMapViewModel extends BaseViewModel {
  final GooglePlaceService _placeService =
      ServiceLocator.instance.googlePlaceService;

  List<DirectionsRoute> routes = [];
  int selectedIndex = 0;
  bool routeLoaded = false;
  bool fetchFailed = false;

  DirectionsRoute? get selectedRoute =>
      routes.isNotEmpty ? routes[selectedIndex] : null;

  /// Fetches driving routes between [pickup] and [dropoff].
  /// If [initialDistanceKm] is provided, selects the route closest to it.
  Future<void> fetchRoutes({
    required LatLng pickup,
    required LatLng dropoff,
    double? initialDistanceKm,
  }) async {
    fetchFailed = false;

    final parsed = await _placeService.fetchDirections(
      origin: pickup,
      destination: dropoff,
    );

    if (parsed.isEmpty) {
      fetchFailed = true;
      notifyListeners();
      return;
    }

    // Find the route closest to initialDistanceKm if provided
    int bestIndex = 0;
    if (initialDistanceKm != null && parsed.length > 1) {
      double minDiff = double.infinity;
      for (int i = 0; i < parsed.length; i++) {
        final diff = (parsed[i].distanceKm - initialDistanceKm).abs();
        if (diff < minDiff) {
          minDiff = diff;
          bestIndex = i;
        }
      }
    }

    routes = parsed;
    selectedIndex = bestIndex;
    routeLoaded = true;
    notifyListeners();
  }

  void selectRoute(int index) {
    if (index == selectedIndex || index < 0 || index >= routes.length) return;
    selectedIndex = index;
    notifyListeners();
  }
}
