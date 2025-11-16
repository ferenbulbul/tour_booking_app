import 'package:flutter/material.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/city_list/city_list_response.dart';
import 'package:tour_booking/models/district/district_dto.dart';
import 'package:tour_booking/models/region/region_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class SearchViewmodel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];

  List<MobileCityDto> cities = [];
  List<MobileDistrictDto> districts = [];
  List<MobileRegionDto> regions = [];

  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedRegionId;

  bool isRegionLoading = false;
  bool isCityLoading = false;
  bool isDistrictLoading = false;

  /// ✅ Bölge çekme
  Future<void> fetchRegions() async {
    isRegionLoading = true;
    notifyListeners();

    try {
      final result = await _tourService.getRegions();

      if (result.isSuccess ?? false) {
        regions = result.data?.regions ?? [];
      } else {
        message = result.message;
        validationErrors = result.validationErrors ?? [];
      }
    } finally {
      isRegionLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Bölge seçilince şehirler çekilir, diğer seçimler sıfırlanır
  Future<void> fetchCities(String regionId) async {
    selectedRegionId = regionId;
    selectedCityId = null;
    selectedDistrictId = null;
    cities = [];
    districts = [];

    isCityLoading = true;
    notifyListeners();

    try {
      final result = await _tourService.getCities(regionId);

      if (result.isSuccess ?? false) {
        cities = result.data?.cities ?? [];
      } else {
        message = result.message;
        validationErrors = result.validationErrors ?? [];
      }
    } finally {
      isCityLoading = false;
      notifyListeners();
    }
  }

  /// ✅ İl seçilince ilçeler çekilir, ilçe sıfırlanır
  Future<void> fetchDistricts(String cityId) async {
    selectedCityId = cityId;
    selectedDistrictId = null;
    districts = [];

    isDistrictLoading = true;
    notifyListeners();

    try {
      final result = await _tourService.getDistricts(cityId);

      if (result.isSuccess ?? false) {
        districts = result.data?.districts ?? [];
      } else {
        message = result.message;
        validationErrors = result.validationErrors ?? [];
      }
    } finally {
      isDistrictLoading = false;
      notifyListeners();
    }
  }

  /// İlçeyi seç
  void selectDistrict(String? districtId) {
    selectedDistrictId = districtId?.isEmpty ?? true ? null : districtId;
    notifyListeners();
  }

  /// (Gerekirse kullanırsın)
  void selectCity(String cityId) {
    selectedCityId = cityId;
    notifyListeners();
  }
}
