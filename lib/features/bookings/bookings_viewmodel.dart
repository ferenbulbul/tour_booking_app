import 'package:flutter/material.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class BookingsViewModel extends ChangeNotifier {
  final TourService _service = TourService();

  /// --- Loading States ---
  bool isLoadingAll = false;
  bool isLoadingCompleted = false;
  bool isLoadingCancelled = false;

  /// --- Lists ---
  List<BookingDto> allBookings = [];
  List<BookingDto> completedBookings = [];
  List<BookingDto> cancelledBookings = [];

  String? message;

  /// --- Filtreli veri çek (ENUM ile) ---
  Future<void> fetchBookingsByStatus(BookingStatus status) async {
    _setLoading(status, true);

    try {
      final resp = await _service.getCustomerBookings(status: status);

      if (resp.isSuccess ?? false) {
        final list = resp.data?.customerBookings ?? [];

        switch (status) {
          case BookingStatus.upcoming:
            allBookings = list;
            break;
          case BookingStatus.completed:
            completedBookings = list;
            break;
          case BookingStatus.cancelled:
            cancelledBookings = list;
            break;
        }
      } else {
        setMessage(resp.message);
      }
    } catch (e) {
      setMessage("Bir hata oluştu: $e");
    } finally {
      _setLoading(status, false);
      notifyListeners();
    }
  }

  Future<void> requestCancellation(String bookingId) async {
    try {
      final resp = await _service.requestCancellation(bookingId: bookingId);

      setMessage(resp.message);

      if (resp.isSuccess ?? false) {
        await fetchBookingsByStatus(BookingStatus.upcoming);
      }
    } catch (e) {
      setMessage("Bir hata oluştu: $e");
    }
  }

  /// --- Loading yönetimi (ENUM tabanlı) ---
  void _setLoading(BookingStatus status, bool value) {
    switch (status) {
      case BookingStatus.upcoming:
        isLoadingAll = value;
        break;
      case BookingStatus.completed:
        isLoadingCompleted = value;
        break;
      case BookingStatus.cancelled:
        isLoadingCancelled = value;
        break;
    }
    notifyListeners();
  }

  void setMessage(String? value) {
    message = value;
    notifyListeners();
  }

  void clearMessage() {
    message = null;
    notifyListeners();
  }
}
