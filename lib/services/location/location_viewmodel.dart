import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/location_update/location_dto.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/services/location/location_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class LocationViewModel with ChangeNotifier {
  final LocationPermissionService _permissionService =
      LocationPermissionService();
  final LocationService _locationService = LocationService();
  TourService _service = TourService();
  Position? _currentPosition;
  bool _isTracking = false;
  LocationPermissionStatus? _permissionStatus;
  bool _hasRequestedCustomerPermissionInThisSession = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  LocationPermissionStatus? get permissionStatus => _permissionStatus;

  Future<void> checkAndHandleLocation(
    UserRole role, {
    bool isCalledFromResumed = false,
  }) async {
    // 1. İzinleri rol bazlı olarak kontrol et ve iste.
    LocationPermissionStatus currentStatus;
    if (role == UserRole.customer) {
      // Müşteri için oturum başına bir kez soran nazik mantık
      var shouldRequest =
          !_hasRequestedCustomerPermissionInThisSession && !isCalledFromResumed;
      currentStatus = await _permissionService.checkAndRequestPermission(
        role: role,
        shouldRequest: shouldRequest,
      );
      if (shouldRequest) {
        _hasRequestedCustomerPermissionInThisSession = true;
      }
    } else {
      // Driver için her zaman soran agresif mantık
      currentStatus = await _permissionService.checkAndRequestPermission(
        role: role,
        shouldRequest: true,
      );
    }

    // ViewModel'ın iç durumunu her zaman güncelle
    _permissionStatus = currentStatus;

    // 2. İzinler yeterliyse, ROL FARK ETMEKSİZİN konum takibini başlat.
    if (currentStatus == LocationPermissionStatus.grantedAlways ||
        currentStatus == LocationPermissionStatus.grantedWhenInUse) {
      print(
        "✅ [ViewModel]: İzinler yeterli. Rol: [$role]. Konum takibi başlatılıyor...",
      );
      await _startLocationStream(role); // <-- BURASI ARTIK ÇAĞRILIYOR!
    }
    // 3. İzinler yetersizse takibi durdur.
    else {
      print(
        "❌ [ViewModel]: Yetersiz izin. Rol: [$role]. Durum: $currentStatus",
      );
      stopTracking();
      if (role == UserRole.driver &&
          currentStatus == LocationPermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    }
    notifyListeners(); // UI'ı son durumdan haberdar et.
  }

  /// HER İKİ ROL İÇİN DE konum takibini başlatan ORTAK metot.
  Future<void> _startLocationStream(UserRole role) async {
    final serviceEnabled = await _locationService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❗ [ViewModel]: CİHAZ KONUM SERVİSLERİ KAPALI!");
      stopTracking();
      return;
    }

    // --- ROL BAZLI ZAMAN VE MESAFE AYARLARI ---
    int updateIntervalInSeconds;
    int distanceFilterInMeters;

    if (role == UserRole.driver) {
      // Driver: Dakikada bir VEYA her 50 metrede bir
      updateIntervalInSeconds = 60;
      distanceFilterInMeters = 50;
    } else {
      // UserRole.customer
      // Customer: Saatte bir VEYA her 1000 metrede (1km) bir
      updateIntervalInSeconds = 3600;
      distanceFilterInMeters = 1000;
    }
    print(
      "ℹ️ Rol: [$role] - Konum Ayarları: ${updateIntervalInSeconds}sn / ${distanceFilterInMeters}m",
    );
    // ----------------------------------------------------

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = _locationService
        .getPositionStream(
          timeIntervalInSeconds: updateIntervalInSeconds,
          distanceFilter: distanceFilterInMeters,
        )
        .listen(
          (position) async {
            _isTracking = true;
            _currentPosition = position;
            final lat = position.latitude;
            final lon = position.longitude;
            print("✅📍 ROL: [$role] - KONUM ALINDI: Enlem=$lat, Boylam=$lon");
            // TODO: Backend'e gönderme işlemini burada yap.
            final location = LocationDto(
              latitude: double.parse(lat.toStringAsFixed(6)),
              longitude: double.parse(lon.toStringAsFixed(6)),
            );
            await _service.locationUpdate(location);
            notifyListeners();
          },
          onError: (error) {
            print("❌ [ViewModel]: Konum stream'inde hata oluştu: $error");
            stopTracking();
          },
        );
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    if (_isTracking) {
      _isTracking = false;
      print("⏹️ [ViewModel]: Konum takibi durduruldu.");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print("🗑️ [ViewModel]: dispose çağrıldı.");
    stopTracking();
    super.dispose();
  }
}
