import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/features/tour_search_detail/screen/summary_screen.dart';
import 'package:tour_booking/models/create_booking_request/create_booking_command.dart';
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
  bool isValid = false;
  String? bookingId;

  List<Vehicle> vehicles = [];
  String? selectedCityId;
  String? selectedDistrictId;
  String? selectedVehicleId;
  String? selectedGuideId;
  int? selectedGuidePrice;
  String? selectedTourPointId;
  DateTime? selectedDate;

  VehicleDetail? vehicle;
  int? setVehiclePrice;
  List<Guide> guides = [];

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
      selectedVehicleId = vehicleId;
      print(selectedVehicleId);
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

  String? get selectedCityName =>
      detail?.cities.firstWhereOrNull((c) => c.id == selectedCityId)?.name;

  String? get selectedDistrictName => detail?.districts
      .firstWhereOrNull((d) => d.id == selectedDistrictId)
      ?.name;

  // Tur noktası adınız genelde detail.title:
  String? get selectedTourPointName => detail?.title;

  void setSelectedGuide(String? GuideId, int? Price) {
    selectedGuideId = GuideId;
    selectedGuidePrice = Price;
    print(selectedGuideId);
    notifyListeners();
  }

  void setSelectedPrice(int? price) {
    setVehiclePrice = price;
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

  Future<void> ControlBooking() async {
    if (selectedCityId == null ||
        selectedDistrictId == null ||
        selectedTourPointId == null ||
        selectedVehicleId == null ||
        selectedDate == null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString('user_role');
    try {
      final req = CreateBookingCommand(
        vehicleId: selectedVehicleId!,
        guideId: selectedGuideId,
        cityId: selectedCityId!,
        districtId: selectedDistrictId!,
        tourPointId: selectedTourPointId!,
        tourPrice: Decimal.parse(setVehiclePrice.toString()),
        date: selectedDate!,
        guidePrice: selectedGuidePrice != null
            ? Decimal.parse(selectedGuidePrice.toString())
            : null,
      );
      final resp = await _tourService.ControlBooking(req);

      if (resp.isSuccess == true && !resp.data!.isValid) {
        errorMessage = resp.message;
        isValid = resp.data!.isValid;
        bookingId = resp.data!.bookingId;
        errorMessage = resp.message;
      }
      if (resp.isSuccess == true && resp.data!.isValid) {
        errorMessage = resp.message;
        isValid = resp.data!.isValid;
        bookingId = resp.data!.bookingId;
        errorMessage = resp.message;
      } else {
        errorMessage = resp.message ?? 'Bilinmeyen hata';
        isValid = false;
      }
    } catch (e) {
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
