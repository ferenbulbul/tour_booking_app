import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/customer_info_response/customer_info_wrapper.dart';
import 'package:tour_booking/models/driver_past_booking/driver_past_booking_wrapper.dart';
import 'package:tour_booking/models/driver_profile/driver_profile.dart';

import 'package:tour_booking/services/core/api_client.dart';

class DriverService {
  final ApiClient _apiClient;

  DriverService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<CustomerInfoWrapper>> getCustomerInfo() async {
    var response = _apiClient.get<CustomerInfoWrapper>(
      path: "/Mobile/customer-info-for-driver",
      queryParams: {},
      fromJson: (json) =>
          CustomerInfoWrapper.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<DriverPastBookingWrapper>> getPastBookings() async {
    return _apiClient.get<DriverPastBookingWrapper>(
      path: "/Mobile/driver-past-bookings",
      fromJson: (json) =>
          DriverPastBookingWrapper.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<DriverProfile>> getDriverProfile() async {
    return _apiClient.get<DriverProfile>(
      path: "/Mobile/driver-profile",
      fromJson: (json) =>
          DriverProfile.fromJson(json as Map<String, dynamic>),
    );
  }
}
