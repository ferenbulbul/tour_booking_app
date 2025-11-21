import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/location_update/location_dto.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/services/location/location_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class LocationViewModel with ChangeNotifier {
  final LocationPermissionService _permissionService =
      LocationPermissionService();
  final LocationService _locationService = LocationService();
  final TourService _service = TourService();

  Position? _currentPosition;
  bool _isTracking = false;
  LocationPermissionStatus? _permissionStatus;
  StreamSubscription<Position>? _sub;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  LocationPermissionStatus? get permissionStatus => _permissionStatus;

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

  Future<void> _startLocationTracking(UserRole role) async {
    final enabled = await _locationService.isLocationServiceEnabled();
    if (!enabled) {
      stopTracking();
      return;
    }

    final interval = (role == UserRole.driver) ? 60 : 3600;
    final distance = (role == UserRole.driver) ? 50 : 1000;

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

          final dto = LocationDto(
            latitude: pos.latitude,
            longitude: pos.longitude,
          );

          await _service.locationUpdate(dto);

          notifyListeners();
        });
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
