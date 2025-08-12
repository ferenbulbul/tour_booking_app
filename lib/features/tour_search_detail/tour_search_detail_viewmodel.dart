import 'package:flutter/material.dart';
import 'package:tour_booking/models/guide/guide.dart';
import 'package:tour_booking/models/tour_guide_request/tour_guide_request.dart';
import 'package:tour_booking/models/tour_point_detail/tour_point_detail.dart';
import 'package:tour_booking/models/tour_vehicle_request/tour_vehicle_request.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourSearchDetailViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  bool isLoading = false;
  bool isVehiclesLoading = false;
  bool isVehicleLoading = false;
  String? errorMessage;
  TourPointDetail? detail;

  List<Vehicle> vehicles = [];
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedVehicle;
  DateTime? selectedDate;
  VehicleDetail? vehicle;
  String? setViheclePrice;
  List<Guide> guides = [];
  String? selectedTourPointId;

  String? tourPointDetailId;
  Future<void> fetchTourPointDetail(String id) async {
    tourPointDetailId = id;
    isLoading = true;
    notifyListeners();

    try {
      final result = await _tourService.getTourPointDetail(id);
      print("tourpoint id ${id} ");
      selectedTourPointId = id;
      if (result.data != null) {
        detail = result.data!.tourPointDetails;
        errorMessage = null;

        // Varsayılan seçimleri yapalım:
        selectedCityId = detail?.cities.firstOrNull?.id;
        selectedDistrictId = detail?.districts
            .firstWhere(
              (d) => d.cityId == selectedCityId,
              orElse: () => detail!.districts.first,
            )
            .id;
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

  Future<void> fetchVehicles() async {
    if (selectedCityId == null ||
        selectedDistrictId == null ||
        tourPointDetailId == null ||
        selectedDate == null)
      return;

    isVehiclesLoading = true;
    notifyListeners();

    try {
      final request = TourVehicleRequest(
        cityId: selectedCityId!,
        districtId: selectedDistrictId!,
        tourPointId: tourPointDetailId!, // bunu viewmodel'e kaydetmiştik
        date: selectedDate!,
      );

      final result = await _tourService.getVehicles(request);

      if (result.isSuccess ?? false) {
        vehicles = result.data!.vehicles ?? [];
        errorMessage = result.message;
      } else {
        errorMessage = result.message;
        vehicles = [];
      }
    } catch (e) {
      errorMessage = 'Hata oluştu: $e';
      vehicles = [];
    } finally {
      isVehiclesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicle(String vehicleId) async {
    isVehicleLoading = true;
    notifyListeners();
    try {
      final result = await _tourService.getVehicle(vehicleId);
      selectedVehicle = result.data!.vehicleDtos!.vehicleId;
      if (result.isSuccess ?? false) {
        vehicle = result.data!.vehicleDtos;
        errorMessage = result.message;
      } else {
        errorMessage = result.message;
        vehicle;
      }
    } catch (e) {
      errorMessage = 'Hata oluştu: $e';
      vehicle;
    } finally {
      isVehicleLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCity(String? cityId) {
    selectedCityId = cityId;
    // şehir değiştiğinde ilçeyi sıfırla veya ilk eşleşeni seç
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

  void setSelectedPrice(String? price) {
    setViheclePrice = price;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> fetchGuides() async {
    if (selectedCityId == null ||
        selectedDistrictId == null ||
        selectedTourPointId == null ||
        selectedDate == null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final req = TourGuideRequest(
        cityId: selectedCityId!,
        districtId: selectedDistrictId!,
        tourPointId: selectedTourPointId!,
        date: selectedDate!,
      );

      final resp = await _tourService.searchGuide(req);

      if (resp.isSuccess == true && resp.data != null) {
        guides = resp.data!.guides;
        errorMessage = resp.message;
      } else {
        guides = [];
        errorMessage = resp.message ?? 'Bilinmeyen hata';
      }
    } catch (e) {
      guides = [];
      errorMessage = 'Hata: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

extension FirstOrNull<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
