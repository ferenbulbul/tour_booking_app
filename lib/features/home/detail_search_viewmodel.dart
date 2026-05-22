import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/recent_search/recent_search_item.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/recent_search/recent_search_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class DetailSearchViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;
  final RecentSearchService _recentService = ServiceLocator.instance.recentSearchService;
  Timer? _debounceTimer;

  List<MobileTourPointsBySearchDto> results = [];
  List<RecentSearchItem> recents = [];
  bool isLoading = false;
  String? errorMessage;
  String query = '';

  /// Load recent searches from local storage.
  Future<void> loadRecents() async {
    recents = await _recentService.getRecentSearches();
    notifyListeners();
  }

  /// Debounced search triggered by text field changes.
  void onSearchChanged(String value) {
    final trimmed = value.trim();
    query = trimmed;

    if (trimmed.isEmpty) {
      results = [];
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      final captured = query;
      if (captured.isEmpty) return;

      try {
        final response = await _tourService.getTourTypesSearch(captured);
        final result = handleResponse<MobileTourPointsResponse>(response);

        if (query != captured) return;

        isLoading = false;
        errorMessage = null;
        if (result.isSuccess && result.data != null) {
          results = result.data!.tourPoints;
        } else {
          results = [];
        }
        notifyListeners();
      } catch (e) {
        debugPrint('DetailSearchViewModel.onSearchChanged: $e');
        isLoading = false;
        results = [];
        errorMessage = tr('error_generic');
        notifyListeners();
      }
    });
  }

  /// Clear search query and results.
  void clearSearch() {
    query = '';
    results = [];
    isLoading = false;
    notifyListeners();
  }

  /// Save a search result as recent and return resolved city info.
  Future<void> saveRecentFromResult(MobileTourPointsBySearchDto p) async {
    final String? resolvedCityId;
    final String? resolvedCityName;
    if (p.type == 'City') {
      resolvedCityId = p.id;
      resolvedCityName = p.name;
    } else {
      resolvedCityId = p.cityId;
      resolvedCityName = p.cityName;
    }

    await _recentService.addRecentSearch(RecentSearchItem(
      id: p.id,
      name: p.name,
      type: p.type,
      timestamp: DateTime.now(),
      cityId: resolvedCityId,
      cityName: resolvedCityName,
      image: p.image,
    ));
  }

  /// Save a popular tour as a recent search.
  Future<void> saveRecentFromPopular(FeaturedTourPointDto point) async {
    await _recentService.addRecentSearch(RecentSearchItem(
      id: point.id,
      name: point.title,
      type: 'Tour',
      timestamp: DateTime.now(),
    ));
  }

  /// Remove a single recent search item.
  Future<void> removeRecent(String id) async {
    await _recentService.removeRecentSearch(id);
    await loadRecents();
  }

  /// Clear all recent searches.
  Future<void> clearRecents() async {
    await _recentService.clearAll();
    recents = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
