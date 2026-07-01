import 'dart:async';
import 'package:flutter/foundation.dart'; // Required for `defaultTargetPlatform`
import 'package:geolocator/geolocator.dart';
import 'package:tour_booking/core/enum/user_role.dart';

class LocationService {
  /// Provides location updates based on specified time and distance thresholds.
  Stream<Position> getPositionStream({
    required UserRole role,
    int timeIntervalInSeconds = 60,
    int distanceFilter = 100,
  }) {
    late LocationSettings settings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: Duration(seconds: timeIntervalInSeconds),

        // Foreground notification for DRIVER role only
        foregroundNotificationConfig: role == UserRole.driver
            ? const ForegroundNotificationConfig(
                notificationText:
                    "Konumunuz arka planda hizmet sunmak için kullanılıyor.",
                notificationTitle: "Konum Paylaşımı Aktif",
                enableWakeLock: true,
              )
            : null,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        // Arka planda konum akışının sürmesi (ve dolayısıyla API isteğinin
        // atılması) için DRIVER rolünde gereklidir.
        allowBackgroundLocationUpdates: role == UserRole.driver,
        // iOS'un duraklatma optimizasyonunu kapat; aksi halde sürücü sabit
        // kaldığında akış otomatik duraklatılır ve geri açılmayabilir.
        pauseLocationUpdatesAutomatically: false,
        // Arka plandayken durum çubuğunda mavi konum göstergesi.
        showBackgroundLocationIndicator: role == UserRole.driver,
        activityType: ActivityType.automotiveNavigation,
      );
    } else {
      settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
