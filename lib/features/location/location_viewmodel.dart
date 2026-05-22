import 'dart:async';
import 'package:flutter/material.dart';
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
  String? _errorMessage;

  // Throttle: last sent position and time
  Position? _lastSentPosition;
  DateTime? _lastSentTime;

  // Customer threshold: 1 km / 1 hour
  static const double _minDistanceMeters = 1000; // 1 km
  static const Duration _minInterval = Duration(hours: 1);

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  LocationPermissionStatus? get permissionStatus => _permissionStatus;
  String? get errorMessage => _errorMessage;

  Future<void> checkAndHandleLocation(UserRole role) async {
    final status = await _permissionService.checkPermission(role);
    _permissionStatus = status;

    if (status == LocationPermissionStatus.grantedAlways ||
        status == LocationPermissionStatus.grantedWhenInUse) {
      await _startLocationTracking(role);
    } else {
      stopTracking();
    }

    notifyListeners();
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
      debugPrint('LocationViewModel._startLocationTracking: $e');
      _errorMessage = 'Failed to get current position: $e';
      notifyListeners();
      // If initial position fails, rely on stream
    }

    final interval = isDriver ? 60 : 3600;
    final distance = isDriver ? 50 : 1000;

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
        });
  }

  /// Send location to server (with throttle check)
  Future<void> _sendToServer(Position pos, {bool force = false}) async {
    if (!force && !_shouldSendUpdate(pos)) return;

    try {
      await _service.locationUpdate(
        LocationDto(latitude: pos.latitude, longitude: pos.longitude),
      );
      _lastSentPosition = pos;
      _lastSentTime = DateTime.now();
    } catch (e) {
      debugPrint('[LocationVM] locationUpdate error: $e');
      _errorMessage = 'Failed to send location update: $e';
      notifyListeners();
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
