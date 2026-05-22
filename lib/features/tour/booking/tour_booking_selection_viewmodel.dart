import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class TourBookingSelectionViewModel extends BaseViewModel {
  final GooglePlaceService _placeService = ServiceLocator.instance.googlePlaceService;

  /// Available departure times (06:00 – 12:00 in 30-minute increments).
  static final List<String> availableTimes = _generateTimes();

  static List<String> _generateTimes() {
    final out = <String>[];
    for (int h = 6; h <= 12; h++) {
      out.add("${h.toString().padLeft(2, '0')}:00");
      if (h != 12) out.add("${h.toString().padLeft(2, '0')}:30");
    }
    return out;
  }

  String? selectedPlaceDesc;
  double? selectedPlaceLat;
  double? selectedPlaceLng;
  DateTime? selectedDate;
  String? selectedTime;
  bool autoSelected = false;
  bool autoSelectedByUserChange = false;

  Future<void> autoSelectPlace(
    String city,
    String district, {
    bool triggeredByUser = false,
  }) async {
    final sw = Stopwatch()..start();
    final result = await _placeService.findDefaultPlace(city, district);
    debugPrint('[AutoSelectPlace] Google Geocoding took ${sw.elapsedMilliseconds}ms (result: ${result != null ? "OK" : "NULL"})');
    if (result == null) return;

    if (!triggeredByUser) {
      autoSelected = true;
    } else {
      autoSelectedByUserChange = true;
    }

    setSelectedPlace(result);
  }

  void setSelectedPlace(PlaceSelection s) {
    selectedPlaceDesc = s.description;
    selectedPlaceLat = s.lat;
    selectedPlaceLng = s.lng;
    notifyListeners();
  }

  void resetPlaceSelection() {
    selectedPlaceDesc = null;
    selectedPlaceLat = null;
    selectedPlaceLng = null;
    selectedDate = null;
    selectedTime = null;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  void reset() {
    resetSilent();
    notifyListeners();
  }

  /// Reset without triggering rebuild — use when followed by autoSelectPlace
  void resetSilent() {
    selectedPlaceDesc = null;
    selectedPlaceLat = null;
    selectedPlaceLng = null;
    selectedDate = null;
    selectedTime = null;
    autoSelected = false;
    autoSelectedByUserChange = false;
  }
}
