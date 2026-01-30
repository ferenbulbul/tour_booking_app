import 'package:flutter/material.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class BookingsViewModel extends ChangeNotifier {
  final TourService _service = TourService();

  bool isLoadingAll = false;
  bool isLoadingCompleted = false;
  bool isLoadingCancelled = false;

  List<BookingDto> allBookings = [];
  List<BookingDto> completedBookings = [];
  List<BookingDto> cancelledBookings = [];
  List<BookingDto> cancellationPendingBookings = [];

  PendingRatingDto? pendingRating;
  bool isRatingLoading = false;

  String? message;

  // ------------------------------------------------------------
  Future<void> fetchBookingsByStatus(BookingStatus status) async {
    _setLoading(status, true);

    try {
      final resp = await _service.getCustomerBookings(status: status);

      if (resp.isSuccess == true) {
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
            cancellationPendingBookings = list
                .where((b) => b.status == "cancellationPending")
                .toList();
            break;
        }
      } else if (resp.message != null) {
        setMessage(resp.message); // 🔥 key gelir (error_generic vs)
      }
    } catch (_) {
      setMessage("error_generic"); // 🔥 backend yoksa buradan
    } finally {
      _setLoading(status, false);
    }
  }

  // ------------------------------------------------------------
  Future<void> requestCancellation(String bookingId) async {
    try {
      final resp = await _service.requestCancellation(bookingId: bookingId);

      if (resp.message != null) {
        setMessage(resp.message); // success / error key
      }

      if (resp.isSuccess == true) {
        await fetchBookingsByStatus(BookingStatus.upcoming);
        await fetchBookingsByStatus(BookingStatus.cancelled);
      }
    } catch (_) {
      setMessage("error_generic");
    }
  }

  // ------------------------------------------------------------
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
    notifyListeners(); // 🔥 SADECE BURADA
  }

  // ------------------------------------------------------------
  void setMessage(String? value) {
    if (message == value) return; // 🔥 aynı mesajı tekrar basma
    message = value;
    notifyListeners();
  }

  void clearMessage() {
    message = null;
    notifyListeners();
  }
}
