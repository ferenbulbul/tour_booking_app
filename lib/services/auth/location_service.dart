import 'dart:async';
import 'package:flutter/foundation.dart'; // `defaultTargetPlatform` için gerekli
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Belirtilen zaman ve mesafe koşullarına göre konum güncellemeleri sağlar.
  Stream<Position> getPositionStream({
    int timeIntervalInSeconds = 60,
    int distanceFilter = 100, // Varsayılan değerler
  }) {
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter, // Parametreyi kullan
        intervalDuration: Duration(
          seconds: timeIntervalInSeconds,
        ), // Parametreyi kullan
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Konumunuz, ilgili hizmetleri sunmak için kullanılıyor.",
          notificationTitle: "Konum Paylaşımı Aktif",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.other,
        distanceFilter: distanceFilter, // Parametreyi kullan
        pauseLocationUpdatesAutomatically:
            true, // Pil tasarrufu için iOS'in duraklatmasına izin ver
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
