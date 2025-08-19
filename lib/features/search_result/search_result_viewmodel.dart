import 'package:flutter/foundation.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourSearchResultsViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  String message = ""; // boş sonuç vb. için
  String? errorMessage; // hata mesajı
  List<TourPoint> tourPoints = [];

  Future<void> fetchTourPoints(TourSearchRequest request) async {
    try {
      isLoading = true;
      message = "";
      errorMessage = null;
      notifyListeners();

      final response = await _tourService.searchTourPoints(request);

      if (response != null && response.data != null) {
        tourPoints = response.data?.tourPoints ?? [];
        message = tourPoints.isEmpty ? "Hiçbir sonuç bulunamadı" : "";
        errorMessage = null;
      } else {
        tourPoints = [];
        errorMessage = response?.message ?? "Bilinmeyen hata";
        message = "";
      }
    } catch (e) {
      tourPoints = [];
      errorMessage = "Bir hata oluştu: $e";
      message = "";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
