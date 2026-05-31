import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/models/popular_destination/popular_destination_dto.dart';
import 'package:tour_booking/models/popular_destination_list/popular_destination_list_dto.dart';
import 'package:tour_booking/models/nearby_list/nearby_list_response.dart';
import 'package:tour_booking/models/nearby_tourpoint/nearby_tour_point_dto.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/models/tour_search_response/tour_search_response.dart';
import 'package:tour_booking/models/tour_type/tour_type_dto.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/recent_search/recent_search_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class HomeViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

  // Featured
  bool isLoadingFeatured = false;
  List<FeaturedTourPointDto> featuredPoints = [];

  // Popular Destinations
  bool isLoadingPopularDestinations = false;
  String? popularDestinationsMessage;
  List<PopularDestinationDto> popularDestinations = [];

  // Tour Types (Categories) — lazy loaded
  bool isLoadingTourTypes = false;
  String? tourTypesMessage;
  List<TourTypeDto> tourTypes = [];

  Future<void> init() async {
    await Future.wait([
      fetchFeaturedTourPoints(),
      fetchPopularDestinations(),
      if (tourTypes.isNotEmpty) fetchTourTypes(),
    ]);
  }

  String? featuredMessage;

  Future<void> fetchFeaturedTourPoints() async {
    isLoadingFeatured = true;
    notifyListeners();
    final response = await _tourService.getFeaturedTourPoints();
    final result = handleResponse<FeaturedTourPointListDto>(response);

    if (result.isSuccess && result.data != null) {
      featuredPoints = List.of(result.data?.tourPoints ?? [])..shuffle();
      featuredMessage = null;
    } else {
      featuredMessage = result.error?.message ?? tr('error_data_load_failed');
    }

    isLoadingFeatured = false;
    notifyListeners();
  }

  Future<void> fetchPopularDestinations() async {
    isLoadingPopularDestinations = true;
    notifyListeners();

    final response = await _tourService.getPopularDestinations();
    final result = handleResponse<PopularDestinationListDto>(response);

    if (result.isSuccess && result.data != null) {
      popularDestinations = result.data?.popularDestinations ?? [];
      popularDestinationsMessage = null;
    } else {
      popularDestinationsMessage =
          result.error?.message ?? tr('error_data_load_failed');
    }

    isLoadingPopularDestinations = false;
    notifyListeners();
  }

  Future<Result<List<TourTypeDto>>> fetchTourTypes() async {
    isLoadingTourTypes = true;
    notifyListeners();

    final result = await _tourService.getTourTypes();

    if (result.isSuccess ?? false) {
      tourTypesMessage = null;
      tourTypes = result.data?.tourTypes ?? [];
    } else {
      tourTypesMessage = result.message;
    }

    isLoadingTourTypes = false;
    notifyListeners();

    return Result.success(tourTypes);
  }

  bool isLoadingSearchByType = false;
  String? messageSearchByType;
  List<TourPoint> searchItemsByType = [];

  Future<void> fetchTourPointsByType(String tourTypeId) async {
    if (tourTypeId.isEmpty) {
      messageSearchByType = tr('error_invalid_category');
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
        // Update from the list field inside TourSearchResponse
        searchItemsByType = resp.data?.tourPoints ?? [];
        messageSearchByType = null;
      } else {
        searchItemsByType = [];
        messageSearchByType = resp.message ?? tr('error_generic');
      }
    } catch (e) {
      debugPrint('HomeViewModel.fetchTourPointsByType: $e');
      searchItemsByType = [];
      messageSearchByType = tr('error_generic');
    } finally {
      isLoadingSearchByType = false;
      notifyListeners();
    }
  }

  List<NearbyTourPointDto> nearbyPoints = [];
  bool isLoadingNearby = false;
  String? messageNearby;

  Future<void> fetchNearbyTourPoints({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoadingNearby = true;
      messageNearby = null;
      notifyListeners();

      final resp = await _tourService.getNearbyTourPoints(
        latitude: latitude,
        longitude: longitude,
      );
      final result = handleResponse<NearbyListResponse>(resp);

      if (result.isSuccess && result.data != null) {
        nearbyPoints = result.data!.nearByList;
        messageNearby = null;
      } else {
        nearbyPoints = [];
        messageNearby = resp.message ?? tr('error_nearby_failed');
      }
    } catch (e) {
      debugPrint('HomeViewModel.fetchNearbyTourPoints: $e');
      nearbyPoints = [];
      messageNearby = tr('error_generic');
    } finally {
      isLoadingNearby = false;
      notifyListeners();
    }
  }

  // ════════════════════════════════════════════════════════════════
  // Continue exploring — clicked tours (2) + searches (2) = max 4
  // Lazy loading: targets are set first, tours are fetched when section becomes visible
  // ════════════════════════════════════════════════════════════════
  final RecentSearchService _recentSearchService = ServiceLocator.instance.recentSearchService;

  List<CityToursSection> citySections = [];

  /// Called when any tour card is tapped
  Future<void> onTourClicked({
    required String cityId,
    required String cityName,
  }) async {
    if (cityId.isEmpty || cityName.isEmpty) return;
    await _recentSearchService.addTourClick(
      cityId: cityId,
      cityName: cityName,
    );
    loadCityTargets();
  }

  /// Only determines target cities — no API call.
  /// Tours are fetched via [fetchCityTours] when each section becomes visible.
  Future<void> loadCityTargets() async {
    try {
      final seen = <String>{};
      final targets = <({String cityId, String cityName})>[];

      // 1) Max 2 unique cities from recently clicked tours
      final clicks = await _recentSearchService.getRecentTourClicks();
      for (final click in clicks) {
        final cId = click['cityId']!;
        final cName = click['cityName']!;
        if (!seen.contains(cId)) {
          seen.add(cId);
          targets.add((cityId: cId, cityName: cName));
          if (targets.length >= 2) break;
        }
      }

      // 2) Fill remaining slots from recent searches (max 4 total)
      final recents = await _recentSearchService.getRecentSearches();
      for (final item in recents) {
        if (targets.length >= 4) break;

        final String? cId;
        final String? cName;

        if (item.type == 'City') {
          cId = item.id;
          cName = item.name;
        } else if (item.cityId != null && item.cityId!.isNotEmpty) {
          cId = item.cityId;
          cName = item.cityName ?? item.name;
        } else {
          continue;
        }

        if (cId != null && !seen.contains(cId)) {
          seen.add(cId);
          targets.add((cityId: cId, cityName: cName));
        }
      }

      if (targets.isEmpty) {
        if (citySections.isNotEmpty) {
          citySections = [];
          notifyListeners();
        }
        return;
      }

      // Preserve existing data — already loaded sections won't be re-fetched
      final existingMap = {for (final s in citySections) s.cityId: s};

      final newSections = targets.map((t) {
        final existing = existingMap[t.cityId];
        if (existing != null && existing.tours.isNotEmpty) return existing;
        return CityToursSection(cityId: t.cityId, cityName: t.cityName);
      }).toList();

      // Skip rebuild if nothing changed
      final currentIds = citySections.map((s) => s.cityId).toList();
      final newIds = newSections.map((s) => s.cityId).toList();
      if (currentIds.length == newIds.length &&
          List.generate(currentIds.length, (i) => currentIds[i] == newIds[i]).every((e) => e)) {
        return;
      }

      citySections = newSections;
      notifyListeners();
    } catch (e) {
      debugPrint('HomeViewModel.loadCityTargets: $e');
      citySections = [];
      notifyListeners();
    }
  }

  /// Fetch tours for a single city from API — called when section becomes visible
  Future<void> fetchCityTours(String cityId) async {
    final idx = citySections.indexWhere((s) => s.cityId == cityId);
    if (idx == -1) return;
    if (citySections[idx].tours.isNotEmpty || citySections[idx].isLoading) return;

    // Loading state
    citySections = [
      for (int i = 0; i < citySections.length; i++)
        if (i == idx)
          CityToursSection(
            cityId: citySections[i].cityId,
            cityName: citySections[i].cityName,
            isLoading: true,
          )
        else
          citySections[i],
    ];
    notifyListeners();

    try {
      final resp = await _tourService.searchTourPoints(
        TourSearchRequest(type: 1, cityId: cityId),
      );
      final result = handleResponse<TourSearchResponse>(resp);
      final tours = (result.isSuccess && result.data != null)
          ? (result.data!.tourPoints ?? [])
          : <TourPoint>[];

      final currentIdx = citySections.indexWhere((s) => s.cityId == cityId);
      if (currentIdx == -1) return;

      citySections = [
        for (int i = 0; i < citySections.length; i++)
          if (i == currentIdx)
            CityToursSection(
              cityId: cityId,
              cityName: citySections[currentIdx].cityName,
              tours: tours,
            )
          else
            citySections[i],
      ];
    } catch (e) {
      debugPrint('HomeViewModel.fetchCityTours: $e');
      final currentIdx = citySections.indexWhere((s) => s.cityId == cityId);
      if (currentIdx == -1) return;

      citySections = [
        for (int i = 0; i < citySections.length; i++)
          if (i == currentIdx)
            CityToursSection(
              cityId: cityId,
              cityName: citySections[currentIdx].cityName,
              errorMessage: tr('error_generic'),
            )
          else
            citySections[i],
      ];
    }
    notifyListeners();
  }
}

/// City-based tour section data for the home page
class CityToursSection {
  final String cityId;
  final String cityName;
  final List<TourPoint> tours;
  final bool isLoading;
  final String? errorMessage;

  const CityToursSection({
    required this.cityId,
    required this.cityName,
    this.tours = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}
