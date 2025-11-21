import 'dart:async';
import 'package:flutter/foundation.dart'; // `defaultTargetPlatform` için gerekli
import 'package:geolocator/geolocator.dart';
import 'package:tour_booking/core/enum/user_role.dart';

class LocationService {
  /// Belirtilen zaman ve mesafe koşullarına göre konum güncellemeleri sağlar.
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

        // 🔥 Sadece DRIVER için foreground notification
        foregroundNotificationConfig: role == UserRole.driver
            ? const ForegroundNotificationConfig(
                notificationText:
                    "Konumunuz arka planda hizmet sunmak için kullanılıyor.",
                notificationTitle: "Konum Paylaşımı Aktif",
                enableWakeLock: true,
              )
            : null,
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
