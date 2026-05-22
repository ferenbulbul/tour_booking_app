import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class PermissionsViewModel extends BaseViewModel {
  bool notificationsAllowed = false;
  bool notificationsPermanentlyDenied = false;

  bool locationAllowed = false;
  bool locationPermanentlyDenied = false;
  final AuthService _authService = ServiceLocator.instance.authService;
  // ------------------------------------------------------
  // LOAD
  // ------------------------------------------------------
  Future<void> loadPermissions() async {
    await _loadNotificationPermission();
    await _loadLocationPermission();
    notifyListeners();
  }

  // ------------------------------------------------------
  // Notification permission — checked via permission_handler
  // ------------------------------------------------------
  Future<void> _loadNotificationPermission() async {
    final notifStatus = await Permission.notification.status;

    notificationsAllowed = notifStatus.isGranted;
    notificationsPermanentlyDenied = notifStatus.isPermanentlyDenied;
  }

  // ------------------------------------------------------
  // Location permission check
  // ------------------------------------------------------
  Future<void> _loadLocationPermission() async {
    final locStatus = await Permission.location.status;

    locationAllowed = locStatus.isGranted;
    locationPermanentlyDenied = locStatus.isPermanentlyDenied;
  }

  // ------------------------------------------------------
  // Request notification permission
  // ------------------------------------------------------
  Future<void> requestNotification() async {
    openAppSettings();

    // Update check via permission_handler
    await _loadNotificationPermission();
    notifyListeners();
  }

  // ------------------------------------------------------
  // Request location permission
  // ------------------------------------------------------
  Future<void> requestLocation() async {
    openAppSettings();
    notifyListeners();
  }

  Future<void> syncPlayerId() async {
    final id = OneSignal.User.pushSubscription.id;
    if (id == null) return;

    await _authService.updatePlayerId(id);
  }
}
