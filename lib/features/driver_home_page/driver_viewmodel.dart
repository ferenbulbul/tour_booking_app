import 'package:flutter/material.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverHomeViewModel extends ChangeNotifier {
  final DriverService _driverService;

  DriverHomeViewModel(this._driverService);

  bool isLoading = false;
  String? error;

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
}
