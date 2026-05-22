import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/district/district_dto.dart';
import 'package:tour_booking/models/region/region_dto.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class SearchViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

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

  /// Fetch regions
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

  /// Fetch cities when a region is selected, reset other selections
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

  /// Fetch districts when a city is selected, reset district
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

  /// Select a district
  void selectDistrict(String? districtId) {
    selectedDistrictId = districtId?.isEmpty ?? true ? null : districtId;
    notifyListeners();
  }

  /// Select a city (use if needed)
  void selectCity(String cityId) {
    selectedCityId = cityId;
    notifyListeners();
  }

  /// Clear city selection (when "All cities" is selected while a region is active)
  void clearCitySelection() {
    selectedCityId = null;
    selectedDistrictId = null;
    districts = [];
    notifyListeners();
  }
}
