import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourSearchResultsViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

  bool isLoading = false;
  String message = ""; // For empty results etc.
  String? errorMessage; // Error message
  List<TourPoint> tourPoints = [];

  Future<void> fetchTourPoints(TourSearchRequest request) async {
    try {
      isLoading = true;
      message = "";
      errorMessage = null;
      notifyListeners();

      final response = await _tourService.searchTourPoints(request);

      if (response.data != null) {
        tourPoints = response.data?.tourPoints ?? [];
        message = tourPoints.isEmpty ? tr('no_results_found') : "";
        errorMessage = null;
      } else {
        tourPoints = [];
        errorMessage = response.message ?? tr('error_generic');
        message = "";
      }
    } catch (e) {
      tourPoints = [];
      errorMessage = tr('error_something_went_wrong', namedArgs: {'error': e.toString()});
      message = "";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    notifyListeners();
  }
}
