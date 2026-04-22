import 'package:flutter/material.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:tour_booking/models/transport/complete_dropoff_request/complete_dropoff_request.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class DriverHomeViewModel extends ChangeNotifier {
  final DriverService _driverService;
  final TransportService _transportService = TransportService();

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
        error = response.message ?? 'Veriler alınamadı';
      }
    } catch (e) {
      error = 'Bir şeyler ters gitti: $e';
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
        dropoffError = resp.message ?? 'error_generic';
        return false;
      }
    } catch (e) {
      dropoffError = 'error_generic';
      return false;
    } finally {
      isCompletingDropoff = false;
      notifyListeners();
    }
  }
}
