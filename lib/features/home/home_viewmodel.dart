import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/models/tour/tour_type_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];
  List<TourTypeDto> tourTypes = [];

  Future<void> init() async {
    await fetchTourTypes();
    await fetchFeaturedTourPoints();
    // ileride başka veri çekme metotları buraya eklenebilir
  }

  Future<Result<List<TourTypeDto>>> fetchTourTypes() async {
    isLoading = true;
    notifyListeners();

    final result = await _tourService.getTourTypes();

    if (result.isSuccess ?? false) {
      message = null;
      validationErrors = [];
      tourTypes = result.data?.tourTypes ?? [];
    } else {
      message = result.message;
      validationErrors = result.validationErrors ?? [];
    }

    isLoading = false;
    notifyListeners();

    return Result.success(tourTypes);
  }

  List<FeaturedTourPointDto> featuredPoints = [];

  Future<void> fetchFeaturedTourPoints() async {
    isLoading = true;
    notifyListeners();

    final response = await _tourService.getFeaturedTourPoints();
    final result = handleResponse<FeaturedTourPointListDto>(response);

    if (result.isSuccess && result.data != null) {
      featuredPoints = result.data!.tourPoints;
      message = null;
    } else {
      message = result.error?.message ?? 'Veri alınamadı';
    }

    isLoading = false;
    notifyListeners();
  }
}
