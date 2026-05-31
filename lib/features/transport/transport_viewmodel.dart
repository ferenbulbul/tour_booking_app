import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class TransportViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;
  final TransportService _transportService = ServiceLocator.instance.transportService;

  // --- City ---
  List<MobileCityDto> cities = [];
  String? selectedCityId;
  String? selectedCityName;
  bool isCitiesLoading = false;

  // --- Pickup ---
  String? pickupAddress;
  double? pickupLat;
  double? pickupLng;

  // --- Dropoff ---
  String? dropoffAddress;
  double? dropoffLat;
  double? dropoffLng;

  // --- Suggested Locations ---
  List<TransportSuggestedLocation> suggestedLocations = [];
  bool isSuggestedLoading = false;

  // --- Date/Time ---
  DateTime? selectedDate;
  String? selectedTime;

  // --- Selected Route Info ---
  double? selectedRouteDistanceKm;
  int? selectedRouteDurationMinutes;
  String? selectedRoutePolyline;

  // --- General ---
  bool isLoading = false;
  String? errorMessage;

  bool get canSearch =>
      pickupLat != null &&
      dropoffLat != null &&
      selectedDate != null &&
      selectedTime != null &&
      selectedCityId != null;

  Future<void> init() async {
    await fetchCities();
    await autoDetectCity();
  }

  // -------------------------------------------------------
  // City
  // -------------------------------------------------------
  Future<void> fetchCities() async {
    isCitiesLoading = true;
    notifyListeners();

    try {
      final regionsResp = await _tourService.getRegions();
      if (regionsResp.isSuccess == true && regionsResp.data != null) {
        final allCities = <MobileCityDto>[];
        for (final region in regionsResp.data!.regions) {
          final citiesResp = await _tourService.getCities(region.id);
          if (citiesResp.isSuccess == true && citiesResp.data != null) {
            allCities.addAll(citiesResp.data!.cities);
          }
        }
        cities = allCities;
      }
    } catch (e) {
      debugPrint('TransportViewModel.fetchCities: $e');
      errorMessage = tr('error_generic');
    }

    isCitiesLoading = false;
    notifyListeners();
  }

  Future<void> autoDetectCity() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final cityName = placemarks.first.administrativeArea ?? '';
        final match = cities.where(
          (c) => c.name.toLowerCase().contains(cityName.toLowerCase()),
        );

        if (match.isNotEmpty) {
          setSelectedCity(match.first.id, match.first.name);
        }
      }
    } catch (e) {
      debugPrint('TransportViewModel.autoDetectCity: $e');
      errorMessage = tr('error_generic');
      notifyListeners();
    }
  }

  void setSelectedCity(String cityId, String cityName) {
    selectedCityId = cityId;
    selectedCityName = cityName;
    notifyListeners();
    fetchSuggestedLocations();
  }

  // -------------------------------------------------------
  // Locations
  // -------------------------------------------------------
  void _clearRouteData() {
    selectedRouteDistanceKm = null;
    selectedRouteDurationMinutes = null;
    selectedRoutePolyline = null;
  }

  void setPickupLocation(PlaceSelection selection) {
    pickupAddress = selection.description;
    pickupLat = selection.lat;
    pickupLng = selection.lng;
    _clearRouteData();
    notifyListeners();
  }

  void setDropoffLocation(PlaceSelection selection) {
    dropoffAddress = selection.description;
    dropoffLat = selection.lat;
    dropoffLng = selection.lng;
    _clearRouteData();
    notifyListeners();
  }

  void setLocationsFromPicker(TransportLocationsResult result) {
    _clearRouteData();
    if (result.pickup != null) {
      pickupAddress = result.pickup!.description;
      pickupLat = result.pickup!.lat;
      pickupLng = result.pickup!.lng;
    }
    if (result.dropoff != null) {
      dropoffAddress = result.dropoff!.description;
      dropoffLat = result.dropoff!.lat;
      dropoffLng = result.dropoff!.lng;
    }
    if (result.distanceKm != null) {
      selectedRouteDistanceKm = result.distanceKm;
      selectedRouteDurationMinutes = result.durationMinutes;
      selectedRoutePolyline = result.routePolyline;
    }
    notifyListeners();
  }

  void setPickupFromSuggested(TransportSuggestedLocation loc) {
    pickupAddress = loc.name;
    pickupLat = loc.latitude;
    pickupLng = loc.longitude;
    notifyListeners();
  }

  void setDropoffFromSuggested(TransportSuggestedLocation loc) {
    dropoffAddress = loc.name;
    dropoffLat = loc.latitude;
    dropoffLng = loc.longitude;
    notifyListeners();
  }

  void swapLocations() {
    final tempAddress = pickupAddress;
    final tempLat = pickupLat;
    final tempLng = pickupLng;

    pickupAddress = dropoffAddress;
    pickupLat = dropoffLat;
    pickupLng = dropoffLng;

    dropoffAddress = tempAddress;
    dropoffLat = tempLat;
    dropoffLng = tempLng;

    _clearRouteData();

    notifyListeners();
  }

  // -------------------------------------------------------
  // Suggested Locations
  // -------------------------------------------------------
  Future<void> fetchSuggestedLocations() async {
    if (selectedCityId == null) return;

    isSuggestedLoading = true;
    notifyListeners();

    try {
      final resp = await _transportService.getSuggestedLocations(
        selectedCityId!,
      );
      if (resp.isSuccess == true && resp.data != null) {
        suggestedLocations = resp.data!.locations;
      }
    } catch (e) {
      debugPrint('TransportViewModel.fetchSuggestedLocations: $e');
      errorMessage = tr('error_generic');
    }

    isSuggestedLoading = false;
    notifyListeners();
  }

  // -------------------------------------------------------
  // Date / Time
  // -------------------------------------------------------
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    selectedTime = time;
    notifyListeners();
  }
}
