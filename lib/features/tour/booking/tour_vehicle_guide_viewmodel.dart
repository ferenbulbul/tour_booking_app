import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/create_booking_request/create_booking_command.dart';
import 'package:tour_booking/models/guide/guide.dart';
import 'package:tour_booking/models/tour_guide_request/tour_guide_request.dart';
import 'package:tour_booking/models/tour_vehicle_request/tour_vehicle_request.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class TourVehicleGuideViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

  // Vehicle state
  List<Vehicle> vehicles = [];
  VehicleDetail? vehicle;
  String? selectedVehicleId;
  num? vehiclePrice;
  bool isVehiclesLoading = false;
  bool isVehicleLoading = false;

  // Guide state
  List<Guide> guides = [];
  String? selectedGuideId;
  num? selectedGuidePrice;
  bool isGuidesLoading = false;

  // Booking state
  String? bookingId;
  bool isValid = false;
  bool isLoading = false;
  String? tourRouteId;
  String? errorMessage;

  Future<void> fetchVehicles({
    required String cityId,
    required String districtId,
    required String tourPointId,
    required DateTime date,
  }) async {
    isVehiclesLoading = true;
    notifyListeners();

    try {
      final request = TourVehicleRequest(
        cityId: cityId,
        districtId: districtId,
        tourPointId: tourPointId,
        date: date,
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
      errorMessage = tr('error_occurred', namedArgs: {'error': e.toString()});
      vehicles = [];
    } finally {
      isVehiclesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicle(VehicleDetailRequest request) async {
    isVehicleLoading = true;
    notifyListeners();
    try {
      final result = await _tourService.getVehicle(request);
      selectedVehicleId = request.vehicleId;
      if (result.isSuccess ?? false) {
        vehicle = result.data!.vehicleDtos;
        errorMessage = result.message;
      } else {
        errorMessage = result.message;
      }
    } catch (e) {
      errorMessage = tr('error_occurred', namedArgs: {'error': e.toString()});
    } finally {
      isVehicleLoading = false;
      notifyListeners();
    }
  }

  void setSelectedPrice(num? price) {
    vehiclePrice = price;
    notifyListeners();
  }

  Future<void> fetchGuides({
    required String cityId,
    required String districtId,
    required String tourPointId,
    required DateTime date,
  }) async {
    isGuidesLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final req = TourGuideRequest(
        cityId: cityId,
        districtId: districtId,
        tourPointId: tourPointId,
        date: date,
      );

      final resp = await _tourService.searchGuide(req);

      if (resp.isSuccess == true && resp.data != null) {
        guides = resp.data!.guides;
        errorMessage = resp.message;
      } else {
        guides = [];
        errorMessage = resp.message ?? tr('error_generic');
      }
    } catch (e) {
      guides = [];
      errorMessage = tr('error_generic_short', namedArgs: {'error': e.toString()});
    } finally {
      isGuidesLoading = false;
      notifyListeners();
    }
  }

  void setSelectedGuide(String? guideId, num? price) {
    selectedGuideId = guideId;
    selectedGuidePrice = price;
    notifyListeners();
  }

  Future<void> controlBooking({
    required String buyerFirstName,
    required String buyerLastName,
    required String buyerEmail,
    required String buyerPhone,
    required String cityId,
    required String districtId,
    required String tourPointId,
    required DateTime date,
    required String departureTime,
    String? locationDescription,
    double? latitude,
    double? longitude,
  }) async {
    if (selectedVehicleId == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final req = CreateBookingCommand(
        vehicleId: selectedVehicleId!,
        guideId: selectedGuideId,
        cityId: cityId,
        districtId: districtId,
        tourPointId: tourPointId,
        tourPrice: Decimal.parse(vehiclePrice.toString()),
        date: date,
        guidePrice: selectedGuidePrice != null
            ? Decimal.parse(selectedGuidePrice.toString())
            : null,
        LocationDescription: locationDescription,
        Latitude: latitude,
        Longitude: longitude,
        departureTime: departureTime,
        buyerFirstName: buyerFirstName,
        buyerLastName: buyerLastName,
        buyerEmail: buyerEmail,
        buyerPhone: buyerPhone,
      );
      final resp = await _tourService.controlBooking(req);

      if (resp.isSuccess == true && resp.data != null) {
        isValid = resp.data!.isValid;
        bookingId = resp.data!.bookingId;
        errorMessage = resp.message;
      } else {
        errorMessage = resp.message ?? tr('error_generic');
        isValid = false;
      }
    } catch (e) {
      errorMessage = tr('error_generic_short', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    resetSilent();
    notifyListeners();
  }

  /// Reset without triggering rebuild
  void resetSilent() {
    vehicles = [];
    vehicle = null;
    selectedVehicleId = null;
    vehiclePrice = null;
    isVehiclesLoading = false;
    isVehicleLoading = false;
    guides = [];
    selectedGuideId = null;
    selectedGuidePrice = null;
    isGuidesLoading = false;
    bookingId = null;
    isValid = false;
    isLoading = false;
    tourRouteId = null;
    errorMessage = null;
  }
}
