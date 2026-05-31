import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/driver_past_booking/driver_past_booking.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverPastOrdersViewModel extends BaseViewModel {
  final DriverService _driverService;

  DriverPastOrdersViewModel(this._driverService);

  bool isLoading = false;
  String? error;

  List<DriverPastBooking> pastBookings = [];

  Future<void> fetchPastBookings() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _driverService.getPastBookings();

      if (response.isSuccess == true && response.data != null) {
        pastBookings = response.data!.bookings;
      } else {
        error = response.message ?? tr('error_data_fetch_failed');
      }
    } catch (e) {
      debugPrint('DriverPastOrdersViewModel.fetchPastBookings: $e');
      error = tr('error_something_went_wrong', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
