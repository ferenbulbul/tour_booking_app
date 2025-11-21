import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/enum/user_role.dart';

enum LocationPermissionStatus {
  grantedAlways,
  grantedWhenInUse,
  denied,
  permanentlyDenied,
}

class LocationPermissionService {
  Future<LocationPermissionStatus> checkPermission(UserRole role) async {
    final permission = (role == UserRole.driver)
        ? Permission.locationAlways
        : Permission.locationWhenInUse;

    final status = await permission.status;

    if (status.isGranted) {
      if (role == UserRole.driver &&
          await Permission.locationAlways.isGranted) {
        return LocationPermissionStatus.grantedAlways;
      }
      return LocationPermissionStatus.grantedWhenInUse;
    }

    if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }

    return LocationPermissionStatus.denied;
  }
}
