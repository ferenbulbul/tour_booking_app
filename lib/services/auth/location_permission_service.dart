import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/enum/user_role.dart';

class LocationPermissionService {
  final UserRole role;

  LocationPermissionService(this.role);

  Future<bool> checkAndRequest() async {
    if (role == UserRole.business) {
      return await _requestBackgroundPermission();
    } else {
      return await _requestWhenInUsePermission();
    }
  }

  Future<bool> _requestWhenInUsePermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    return status.isGranted;
  }

  Future<bool> _requestBackgroundPermission() async {
    var status = await Permission.locationAlways.status;

    if (!status.isGranted) {
      final foregroundStatus = await Permission.locationWhenInUse.request();

      if (foregroundStatus.isGranted) {
        status = await Permission.locationAlways.request();
      }
    }

    return status.isGranted;
  }
}
