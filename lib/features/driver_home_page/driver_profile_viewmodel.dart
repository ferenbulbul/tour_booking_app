import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/driver_profile/driver_profile.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverProfileViewModel extends BaseViewModel {
  final DriverService _driverService;

  DriverProfileViewModel(this._driverService);

  bool isLoading = false;
  String? error;

  DriverProfile? profile;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _driverService.getDriverProfile();

      if (response.isSuccess == true && response.data != null) {
        profile = response.data;
      } else {
        error = response.message ?? tr('error_data_fetch_failed');
      }
    } catch (e) {
      error = tr('error_something_went_wrong', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
