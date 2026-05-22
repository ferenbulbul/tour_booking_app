import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class BookingsViewModel extends BaseViewModel {
  final TourService _service = ServiceLocator.instance.tourService;

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
        setMessage(resp.message); // Key arrives (error_generic etc.)
      }
    } catch (e) {
      debugPrint('BookingsViewModel.fetchBookingsByStatus: $e');
      setMessage(tr('error_generic'));
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
    } catch (e) {
      debugPrint('BookingsViewModel.requestCancellation: $e');
      setMessage(tr('error_generic'));
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
    notifyListeners(); // Only here
  }

  // ------------------------------------------------------------
  void setMessage(String? value) {
    if (message == value) return; // Skip duplicate messages
    message = value;
    notifyListeners();
  }

  void clearMessage() {
    message = null;
    notifyListeners();
  }
}
