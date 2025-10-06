import 'package:flutter/material.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class BookingsViewModel extends ChangeNotifier {
  final TourService _bookingService = TourService();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];
  List<BookingDto> bookings = [];

  /// 🔹 Geçmiş siparişleri getir
  Future<void> fetchBookings() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _bookingService.getCustomerBookings();

      if (result.isSuccess ?? false) {
        bookings = result.data?.customerBookings ?? [];
      } else {
        message = result.message ?? "Bilinmeyen bir hata oluştu";
        validationErrors = result.validationErrors ?? [];
      }
    } catch (e) {
      message = "Bir hata oluştu: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
