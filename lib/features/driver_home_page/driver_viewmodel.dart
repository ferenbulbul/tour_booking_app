import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:tour_booking/models/transport/complete_dropoff_request/complete_dropoff_request.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class DriverHomeViewModel extends BaseViewModel {
  final DriverService _driverService;
  final TransportService _transportService = ServiceLocator.instance.transportService;

  DriverHomeViewModel(this._driverService);

  bool isLoading = false;
  String? error;
  bool isCompletingDropoff = false;
  String? dropoffError;

  List<CustomerInfo> customerList = [];

  Future<void> refresh() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _driverService.getCustomerInfo();

      if (response.isSuccess == true && response.data != null) {
        customerList = response.data!.customerInfo;
      } else {
        error = response.message ?? tr('error_data_fetch_failed');
      }
    } catch (e, st) {
      debugPrint('DriverHomeViewModel.refresh: $e\n$st');
      error = tr('error_something_went_wrong', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completeDropoff(String bookingId) async {
    isCompletingDropoff = true;
    dropoffError = null;
    notifyListeners();

    try {
      final req = TransportCompleteDropoffRequest(bookingId: bookingId);
      final resp = await _transportService.completeDropoff(req);

      if (resp.isSuccess == true) {
        await refresh();
        return true;
      } else {
        dropoffError = resp.message ?? tr('error_generic');
        return false;
      }
    } catch (e) {
      debugPrint('DriverHomeViewModel.completeDropoff: $e');
      dropoffError = tr('error_generic');
      return false;
    } finally {
      isCompletingDropoff = false;
      notifyListeners();
    }
  }
}
