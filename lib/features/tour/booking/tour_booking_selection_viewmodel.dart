import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/models/place_section/place_section.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';

class TourBookingSelectionViewModel extends ChangeNotifier {
  final GooglePlaceService _placeService = GooglePlaceService();

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
