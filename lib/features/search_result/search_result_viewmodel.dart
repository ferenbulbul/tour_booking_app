import 'package:flutter/material.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourSearchResultsViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  List<TourPoint> tourPoints = [];
  String? errorMessage;

  Future<void> fetchTourPoints(TourSearchRequest request) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _tourService.searchTourPoints(request);
      if (response != null) {
        tourPoints = response.data!.tourPoints;
        errorMessage = null;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = 'Bir hata oluştu: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
