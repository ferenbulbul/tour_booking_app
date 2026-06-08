import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/tour_point_detail/tour_point_detail.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourDetailViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

  /// In-memory cache for tour point details (survives navigation)
  static final Map<String, TourPointDetail> _detailCache = {};

  bool isLoading = false;
  String? errorMessage;
  TourPointDetail? detail;
  String? tourPointDetailId;
  String? tourPointImage;
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedTourPointId;
  bool _isFavorite = false;

  // Gallery image cache — recomputed only when detail changes
  String? _galleryDetailId;
  String _galleryHeroImage = '';
  List<String> _galleryImages = [];

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
      _applyDetail(id, cached);
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final result = await _tourService.getTourPointDetail(id);
      selectedTourPointId = id;
      if (result.data != null) {
        final fetched = result.data!.tourPointDetails;
        _detailCache[id] = fetched; // Cache for future visits
        _applyDetail(id, fetched);
      } else {
        errorMessage = result.message ?? tr('error_generic');
      }
    } catch (e) {
      errorMessage = tr('error_occurred', namedArgs: {'error': e.toString()});
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
    tourPointImage = d.mainImage;
    selectedCityId = d.cities.firstOrNull?.id;
    selectedDistrictId = d.districts
            .firstWhereOrNull((dd) => dd.cityId == selectedCityId)
            ?.id ??
        d.districts.firstOrNull?.id;
  }

  /// Build a deduplicated gallery image list from [heroImage] and the current
  /// [detail]. The result is cached internally and only recomputed when the
  /// detail or heroImage changes.
  List<String> buildGalleryImages(String heroImage) {
    if (_galleryDetailId == detail?.id && _galleryHeroImage == heroImage) {
      return _galleryImages;
    }
    _galleryDetailId = detail?.id;
    _galleryHeroImage = heroImage;

    final images = <String>[];
    if (heroImage.isNotEmpty) {
      images.add(heroImage);
    }
    if (detail != null) {
      if (detail!.mainImage.isNotEmpty &&
          detail!.mainImage != heroImage &&
          !images.contains(detail!.mainImage)) {
        images.add(detail!.mainImage);
      }
      for (final img in detail!.otherImages) {
        if (img.isNotEmpty && !images.contains(img)) {
          images.add(img);
        }
      }
    }
    _galleryImages = images;
    return _galleryImages;
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
    tourPointImage = null;
    detail = null;
    _isFavorite = false;
    isLoading = false;
    errorMessage = null;
    _galleryDetailId = null;
    _galleryHeroImage = '';
    _galleryImages = [];
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
