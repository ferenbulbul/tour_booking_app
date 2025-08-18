import 'package:flutter/material.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourSearchResultsViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  List<TourPoint> tourPoints = [];
  String? errorMessage;

  Future<void> fetchTourPoints(
    TourSearchRequest request,
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _tourService.searchTourPoints(request);
      if (response != null && response.data != null) {
        tourPoints = response.data?.tourPoints ?? [];
        if (tourPoints.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            UIHelper.showError(context, "Hiçbir sonuç bulunamadı");
          });
        }
        errorMessage = null;
      } else {
        errorMessage = response?.message ?? 'Bilinmeyen hata';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          UIHelper.showError(context, errorMessage!);
        });
      }
    } catch (e) {
      errorMessage = 'Bir hata oluştu: $e';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UIHelper.showError(context, errorMessage!);
      });
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
