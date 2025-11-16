import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/models/nearby_list/nearby_list_response.dart';
import 'package:tour_booking/models/nearby_tourpoint/nearby_tour_point_dto.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_response/tour_search_response.dart';
import 'package:tour_booking/models/tour_type/tour_type_dto.dart';
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
    await fetchNearbyTourPoints();
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
    await Future.delayed(const Duration(seconds: 10));
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

  bool isLoadingSearchByType = false;
  String? messageSearchByType;
  List<TourPoint> searchItemsByType = [];

  Future<void> fetchTourPointsByType(String tourTypeId) async {
    if (tourTypeId.isEmpty) {
      messageSearchByType = "Geçersiz kategori.";
      notifyListeners();
      return;
    }

    try {
      isLoadingSearchByType = true;
      messageSearchByType = null;
      notifyListeners();

      final resp = await _tourService.searchTourPointsByTypeId(
        tourTypeId: tourTypeId,
      );
      final result = handleResponse<TourSearchResponse>(resp);

      if (result.isSuccess && resp.data != null) {
        // TourSearchResponse içindeki liste alanına göre güncelle
        searchItemsByType = resp.data?.tourPoints ?? [];
        messageSearchByType = null;
      } else {
        searchItemsByType = [];
        messageSearchByType = resp.message ?? "Bir hata oluştu";
      }
    } catch (e) {
      searchItemsByType = [];
      messageSearchByType = e.toString();
    } finally {
      isLoadingSearchByType = false;
      notifyListeners();
    }
  }

  List<NearbyTourPointDto> nearbyPoints = [];
  bool isLoadingNearby = false;
  String? messageNearby;

  Future<void> fetchNearbyTourPoints() async {
    try {
      isLoadingNearby = true;
      messageNearby = null;
      notifyListeners();

      final resp = await _tourService.getNearbyTourPoints();
      final result = handleResponse<NearbyListResponse>(resp);

      if (result.isSuccess && result.data != null) {
        nearbyPoints = result.data!.nearByList;
        messageNearby = null;
      } else {
        nearbyPoints = [];
        messageNearby = resp.message ?? "Yakın yerler alınamadı";
      }
    } catch (e) {
      nearbyPoints = [];
      messageNearby = e.toString();
    } finally {
      isLoadingNearby = false;
      notifyListeners();
    }
  }
}
