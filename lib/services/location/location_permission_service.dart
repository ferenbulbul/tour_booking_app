import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/enum/user_role.dart';

enum LocationPermissionStatus {
  grantedAlways,
  grantedWhenInUse,
  denied,
  permanentlyDenied,
}

class LocationPermissionService {
  /// Only checks the current permission status — never shows a dialog.
  Future<LocationPermissionStatus> checkPermission(UserRole role) async {
    if (role == UserRole.driver) {
      if (await Permission.locationAlways.isGranted) {
        return LocationPermissionStatus.grantedAlways;
      }
      if (await Permission.locationWhenInUse.isGranted) {
        return LocationPermissionStatus.grantedWhenInUse;
      }
    } else {
      if (await Permission.locationWhenInUse.isGranted) {
        return LocationPermissionStatus.grantedWhenInUse;
      }
    }

    final status = await Permission.locationWhenInUse.status;
    if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }

    return LocationPermissionStatus.denied;
  }

  /// Requests location permission from the OS.
  ///
  /// For drivers:
  ///   1. Requests [whenInUse] via system dialog (if not already granted).
  ///   2. Checks if [always] is already granted.
  ///   3. If not, returns [grantedWhenInUse] — the caller is responsible
  ///      for showing a custom dialog that directs the user to Settings
  ///      to enable "Always Allow". We intentionally skip
  ///      [Permission.locationAlways.request()] because the system dialog
  ///      is unreliable across OS versions and confuses users.
  ///
  /// For customers: just requests [whenInUse].
  Future<LocationPermissionStatus> requestPermission(UserRole role) async {
    if (role == UserRole.driver) {
      // Step 1: Ensure whenInUse is granted (skip if already granted)
      if (!await Permission.locationWhenInUse.isGranted) {
        final status = await Permission.locationWhenInUse.request();
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            return LocationPermissionStatus.permanentlyDenied;
          }
          return LocationPermissionStatus.denied;
        }
      }

      // Step 2: Check if always is already granted (e.g. user set it
      // from Settings on a previous attempt)
      if (await Permission.locationAlways.isGranted) {
        return LocationPermissionStatus.grantedAlways;
      }

      // Step 3: Return grantedWhenInUse — caller will show a rationale
      // dialog before requesting always via [requestAlwaysPermission].
      return LocationPermissionStatus.grantedWhenInUse;
    } else {
      // Customer: just whenInUse
      final status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        return LocationPermissionStatus.grantedWhenInUse;
      }
      if (status.isPermanentlyDenied) {
        return LocationPermissionStatus.permanentlyDenied;
      }
      return LocationPermissionStatus.denied;
    }
  }

  /// Requests only the background (always) location permission.
  /// Call this after [whenInUse] is already granted and a rationale
  /// dialog has been shown to the user.
  Future<LocationPermissionStatus> requestAlwaysPermission() async {
    if (await Permission.locationAlways.isGranted) {
      return LocationPermissionStatus.grantedAlways;
    }

    final status = await Permission.locationAlways.request();
    if (status.isGranted) {
      return LocationPermissionStatus.grantedAlways;
    }

    return LocationPermissionStatus.grantedWhenInUse;
  }
}
