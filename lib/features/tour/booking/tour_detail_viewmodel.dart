import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/models/tour_point_detail/tour_point_detail.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourDetailViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  /// In-memory cache for tour point details (survives navigation)
  static final Map<String, TourPointDetail> _detailCache = {};

  bool isLoading = false;
  String? errorMessage;
  TourPointDetail? detail;
  String? tourPointDetailId;
  String? tourpointImage;
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedTourPointId;
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  String? get selectedCityName =>
      detail?.cities.firstWhereOrNull((c) => c.id == selectedCityId)?.name;

  String? get selectedDistrictName => detail?.districts
      .firstWhereOrNull((d) => d.id == selectedDistrictId)
      ?.name;

  String? get selectedTourPointName => detail?.title;

  Future<void> fetchTourPointDetail(String id) async {
    tourPointDetailId = id;
    isLoading = true;

    // Check cache first — instant load for previously visited tour points
    final cached = _detailCache[id];
    if (cached != null) {
      debugPrint('[TourDetail] Cache HIT for $id');
      _applyDetail(id, cached);
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final sw = Stopwatch()..start();
      final result = await _tourService.getTourPointDetail(id);
      debugPrint('[TourDetail] API call took ${sw.elapsedMilliseconds}ms');
      selectedTourPointId = id;
      if (result.data != null) {
        final fetched = result.data!.tourPointDetails;
        _detailCache[id] = fetched; // Cache for future visits
        _applyDetail(id, fetched);
      } else {
        errorMessage = result.message ?? 'Bilinmeyen hata';
      }
    } catch (e) {
      errorMessage = 'Hata oluştu: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _applyDetail(String id, TourPointDetail d) {
    selectedTourPointId = id;
    detail = d;
    errorMessage = null;
    _isFavorite = d.isFavorites;
    tourpointImage = d.mainImage;
    selectedCityId = d.cities.firstOrNull?.id;
    selectedDistrictId = d.districts
            .firstWhereOrNull((dd) => dd.cityId == selectedCityId)
            ?.id ??
        d.districts.firstOrNull?.id;
  }

  void setSelectedCity(String? cityId) {
    selectedCityId = cityId;

    final filtered = detail?.districts
        .where((d) => d.cityId == selectedCityId)
        .toList();

    selectedDistrictId = filtered?.isNotEmpty == true
        ? filtered!.first.id
        : null;

    notifyListeners();
  }

  void setSelectedDistrict(String? districtId) {
    selectedDistrictId = districtId;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void setInitialFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  void reset() {
    resetSilent();
    notifyListeners();
  }

  /// Reset without triggering rebuild — use when followed by fetch
  void resetSilent() {
    selectedCityId = null;
    selectedDistrictId = null;
    selectedTourPointId = null;
    tourPointDetailId = null;
    tourpointImage = null;
    detail = null;
    _isFavorite = false;
    isLoading = false;
    errorMessage = null;
  }
}

extension FirstOrNull<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}

extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
