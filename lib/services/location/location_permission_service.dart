import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/enum/user_role.dart';

enum LocationPermissionStatus {
  grantedAlways,
  grantedWhenInUse,
  denied,
  permanentlyDenied,
}

class LocationPermissionService {
  /// Rol bazlı konum iznini kontrol eder ve 'shouldRequest' true ise ister.
  Future<LocationPermissionStatus> checkAndRequestPermission({
    required UserRole role,
    required bool shouldRequest,
  }) async {
    final permission = (role == UserRole.driver)
        ? Permission.locationAlways
        : Permission.locationWhenInUse;

    var status = await permission.status;

    // Zaten izin verilmişse, durumu direkt döndür.
    if (status.isGranted) {
      // Driver için bile olsa, 'always' izni verildiyse 'grantedAlways' döndür.
      if (role == UserRole.driver &&
          await Permission.locationAlways.isGranted) {
        return LocationPermissionStatus.grantedAlways;
      }
      return LocationPermissionStatus.grantedWhenInUse;
    }

    // Kalıcı reddedilmişse, durumu direkt döndür.
    if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }

    // Eğer istek yapmamamız gerekiyorsa (shouldRequest == false),
    // mevcut 'denied' durumunu döndür ve diyalog gösterme.
    if (!shouldRequest) {
      return LocationPermissionStatus.denied;
    }

    // --- Bu noktadan sonra shouldRequest == true demektir, yani diyalog göstereceğiz ---

    // Driver rolü için karmaşık istek mantığı
    if (role == UserRole.driver) {
      return _handleDriverPermissionRequest();
    }
    // Customer rolü için basit istek mantığı
    else {
      final requestedStatus = await Permission.locationWhenInUse.request();
      if (requestedStatus.isGranted)
        return LocationPermissionStatus.grantedWhenInUse;
      if (requestedStatus.isPermanentlyDenied)
        return LocationPermissionStatus.permanentlyDenied;
      return LocationPermissionStatus.denied;
    }
  }

  // Driver için izin isteme mantığını ayıran özel metot
  Future<LocationPermissionStatus> _handleDriverPermissionRequest() async {
    // Önce 'WhenInUse' iznini iste, çünkü 'Always' için bu bir ön koşul.
    final whenInUseStatus = await Permission.locationWhenInUse.request();

    if (whenInUseStatus.isGranted) {
      // Ön plan izni alındıysa, şimdi arka plan için sor.
      final alwaysStatus = await Permission.locationAlways.request();
      if (alwaysStatus.isGranted) {
        return LocationPermissionStatus.grantedAlways;
      }
      // Arka planı vermedi ama ön planı verdi.
      return LocationPermissionStatus.grantedWhenInUse;
    }

    if (whenInUseStatus.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }

    return LocationPermissionStatus.denied;
  }
}
