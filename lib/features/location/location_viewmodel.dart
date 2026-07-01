import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/location_update/location_dto.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/services/location/location_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class LocationViewModel extends BaseViewModel {
  final LocationPermissionService _permissionService =
      ServiceLocator.instance.locationPermissionService;
  final LocationService _locationService =
      ServiceLocator.instance.locationService;
  final TourService _service = ServiceLocator.instance.tourService;

  Position? _currentPosition;
  bool _isTracking = false;
  LocationPermissionStatus? _permissionStatus;
  StreamSubscription<Position>? _sub;
  Timer? _heartbeat;
  String? _errorMessage;

  // Throttle: last sent position and time
  Position? _lastSentPosition;
  DateTime? _lastSentTime;

  // Customer threshold: 1 km / 1 hour
  static const double _minDistanceMeters = 1000; // 1 km
  static const Duration _minInterval = Duration(hours: 1);

  // Driver: sabit dururken bile konumu taze tutmak için heartbeat aralığı.
  // Konum akışı (stream) hareket olmadığında tetiklenmediği için, backoffice
  // haritasındaki konumun bayatlamaması adına periyodik gönderim yapılır.
  static const Duration _driverHeartbeat = Duration(seconds: 15);

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  LocationPermissionStatus? get permissionStatus => _permissionStatus;
  String? get errorMessage => _errorMessage;

  /// Checks location permission and starts tracking if granted.
  /// Set [requestIfDenied] to true to prompt the OS permission dialog.
  ///
  /// For drivers: tracking only starts with [grantedAlways].
  /// For customers: tracking starts with [grantedWhenInUse] or [grantedAlways].
  ///
  /// Returns the final [LocationPermissionStatus].
  Future<LocationPermissionStatus> checkAndHandleLocation(
    UserRole role, {
    bool requestIfDenied = false,
  }) async {
    var status = await _permissionService.checkPermission(role);

    if (requestIfDenied) {
      // Request permission if denied OR if driver needs always but only has whenInUse
      if (status == LocationPermissionStatus.denied ||
          (role == UserRole.driver &&
              status == LocationPermissionStatus.grantedWhenInUse)) {
        status = await _permissionService.requestPermission(role);
      }
    }

    _permissionStatus = status;

    // Drivers MUST have grantedAlways to track.
    // Customers can track with grantedWhenInUse.
    final canTrack = (role == UserRole.driver)
        ? status == LocationPermissionStatus.grantedAlways
        : (status == LocationPermissionStatus.grantedAlways ||
            status == LocationPermissionStatus.grantedWhenInUse);

    if (canTrack) {
      await _startLocationTracking(role);
    } else {
      stopTracking();
    }

    notifyListeners();
    return status;
  }

  /// Only requests permission and updates [permissionStatus].
  /// Does NOT start or stop tracking.
  /// Use this from informational UI (e.g. status banner) that should not
  /// independently control the location stream.
  Future<LocationPermissionStatus> requestPermissionOnly(UserRole role) async {
    var status = await _permissionService.checkPermission(role);

    if (status == LocationPermissionStatus.denied ||
        (role == UserRole.driver &&
            status == LocationPermissionStatus.grantedWhenInUse)) {
      status = await _permissionService.requestPermission(role);
    }

    _permissionStatus = status;
    notifyListeners();
    return status;
  }

  /// Requests background (always) permission and starts tracking if granted.
  /// Call after showing a rationale dialog to the user.
  Future<LocationPermissionStatus> requestAlwaysAndTrack() async {
    final status = await _permissionService.requestAlwaysPermission();
    _permissionStatus = status;

    if (status == LocationPermissionStatus.grantedAlways) {
      await _startLocationTracking(UserRole.driver);
    }

    notifyListeners();
    return status;
  }

  /// Force send location (e.g. when entering Nearby page)
  Future<void> sendLocationUpdate() async {
    final pos = _currentPosition;
    if (pos == null) return;
    await _sendToServer(pos, force: true);
  }

  Future<void> _startLocationTracking(UserRole role) async {
    final enabled = await _locationService.isLocationServiceEnabled();
    if (!enabled) {
      stopTracking();
      return;
    }

    final isDriver = role == UserRole.driver;

    // Get current position immediately
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _currentPosition = pos;
      _isTracking = true;

      // Driver always sends, customer is subject to throttle
      await _sendToServer(pos, force: isDriver);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to get current position: $e';
      notifyListeners();
      // If initial position fails, rely on stream
    }

    // Driver: sık ve düşük mesafe eşiği (anlık takip).
    final interval = isDriver ? 10 : 3600;
    final distance = isDriver ? 15 : 1000;

    _sub?.cancel();
    _sub = _locationService
        .getPositionStream(
          timeIntervalInSeconds: interval,
          distanceFilter: distance,
          role: role,
        )
        .listen((pos) async {
          _isTracking = true;
          _currentPosition = pos;
          await _sendToServer(pos, force: isDriver);
          notifyListeners();
        }, onError: (_) {
          // Akış hatasında takip durmasın; heartbeat ve sonraki emisyonlar sürer.
        });

    // Driver: hareket olmasa da konumu taze tutmak için periyodik gönderim.
    _heartbeat?.cancel();
    if (isDriver) {
      _heartbeat = Timer.periodic(_driverHeartbeat, (_) async {
        try {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 10),
            ),
          );
          _currentPosition = pos;
          await _sendToServer(pos, force: true);
        } catch (_) {
          // Taze konum alınamazsa son bilinen konumu gönder.
          final last = _currentPosition;
          if (last != null) await _sendToServer(last, force: true);
        }
      });
    }
  }

  /// Send location to server (with throttle check + tek seferlik retry)
  Future<void> _sendToServer(Position pos, {bool force = false}) async {
    if (!force && !_shouldSendUpdate(pos)) return;

    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        await _service.locationUpdate(
          LocationDto(latitude: pos.latitude, longitude: pos.longitude),
        );
        _lastSentPosition = pos;
        _lastSentTime = DateTime.now();
        return;
      } catch (e) {
        _errorMessage = 'Failed to send location update: $e';
        if (attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        notifyListeners();
      }
    }
  }

  /// Throttle: less than 1 km movement + less than 1 hour elapsed -> skip sending
  bool _shouldSendUpdate(Position newPos) {
    // Send if never sent before
    if (_lastSentPosition == null || _lastSentTime == null) return true;

    // Time check: send if 1 hour has passed
    final elapsed = DateTime.now().difference(_lastSentTime!);
    if (elapsed >= _minInterval) return true;

    // Distance check: send if moved more than 1 km
    final distance = Geolocator.distanceBetween(
      _lastSentPosition!.latitude,
      _lastSentPosition!.longitude,
      newPos.latitude,
      newPos.longitude,
    );
    if (distance >= _minDistanceMeters) return true;

    return false;
  }

  void stopTracking() {
    _sub?.cancel();
    _sub = null;
    _heartbeat?.cancel();
    _heartbeat = null;

    if (_isTracking) {
      _isTracking = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
