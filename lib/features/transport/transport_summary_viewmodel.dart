import 'package:flutter/material.dart';
import 'package:tour_booking/models/transport/calculate_price_request/calculate_price_request.dart';
import 'package:tour_booking/models/transport/create_transport_booking_request/create_transport_booking_request.dart';
import 'package:tour_booking/models/transport/transport_price_result/transport_price_result.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class TransportSummaryViewModel extends ChangeNotifier {
  final TransportService _service = TransportService();

  bool isLoading = false;
  bool isBooking = false;
  String? errorMessage;
  TransportPriceResult? priceResult;
  String? bookingId;

  // Context from previous screens
  TransportVehicle? selectedVehicle;
  String? pickupAddress;
  double? pickupLat;
  double? pickupLng;
  String? dropoffAddress;
  double? dropoffLat;
  double? dropoffLng;
  DateTime? selectedDate;
  String? selectedTime;
  double? clientDistanceKm;
  int? clientDurationMinutes;

  void setContext({
    required TransportVehicle vehicle,
    required String? pickup,
    required double? pLat,
    required double? pLng,
    required String? dropoff,
    required double? dLat,
    required double? dLng,
    required DateTime? date,
    required String? time,
    double? distanceKm,
    int? durationMinutes,
  }) {
    selectedVehicle = vehicle;
    pickupAddress = pickup;
    pickupLat = pLat;
    pickupLng = pLng;
    dropoffAddress = dropoff;
    dropoffLat = dLat;
    dropoffLng = dLng;
    selectedDate = date;
    selectedTime = time;
    clientDistanceKm = distanceKm;
    clientDurationMinutes = durationMinutes;
  }

  Future<void> calculatePrice() async {
    if (selectedVehicle == null ||
        pickupLat == null ||
        pickupLng == null ||
        dropoffLat == null ||
        dropoffLng == null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      debugPrint('🔴 CALCULATE PRICE: clientDistanceKm=$clientDistanceKm, clientDurationMinutes=$clientDurationMinutes');
      final request = TransportCalculatePriceRequest(
        transportPricingId: selectedVehicle!.transportPricingId,
        pickupLatitude: pickupLat!,
        pickupLongitude: pickupLng!,
        dropoffLatitude: dropoffLat!,
        dropoffLongitude: dropoffLng!,
        clientDistanceKm: clientDistanceKm,
        clientDurationMinutes: clientDurationMinutes,
      );

      final resp = await _service.calculatePrice(request);
      if (resp.isSuccess == true && resp.data != null) {
        priceResult = resp.data;
      } else {
        errorMessage = resp.message ?? 'error_generic';
      }
    } catch (e) {
      errorMessage = 'error_generic';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBooking({
    required String buyerFirstName,
    required String buyerLastName,
    required String buyerEmail,
    required String buyerPhone,
  }) async {
    if (selectedVehicle == null ||
        pickupLat == null ||
        dropoffLat == null ||
        selectedDate == null ||
        selectedTime == null) {
      return;
    }

    isBooking = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = CreateTransportBookingRequest(
        transportPricingId: selectedVehicle!.transportPricingId,
        date: selectedDate!,
        pickupTime: selectedTime!,
        pickupAddress: pickupAddress ?? '',
        pickupLatitude: pickupLat!,
        pickupLongitude: pickupLng!,
        dropoffAddress: dropoffAddress ?? '',
        dropoffLatitude: dropoffLat!,
        dropoffLongitude: dropoffLng!,
        buyerFirstName: buyerFirstName,
        buyerLastName: buyerLastName,
        buyerEmail: buyerEmail,
        buyerPhone: buyerPhone,
      );

      final resp = await _service.createBooking(request);
      if (resp.isSuccess == true && resp.data != null) {
        bookingId = resp.data!.bookingId;
      } else {
        errorMessage = resp.message ?? 'error_generic';
      }
    } catch (e) {
      errorMessage = 'error_generic';
    } finally {
      isBooking = false;
      notifyListeners();
    }
  }
}
