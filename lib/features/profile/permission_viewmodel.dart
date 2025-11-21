import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class PermissionsViewModel extends ChangeNotifier {
  bool notificationsAllowed = false;
  bool notificationsPermanentlyDenied = false;

  bool locationAllowed = false;
  bool locationPermanentlyDenied = false;
  final AuthService _authService = AuthService();
  // ------------------------------------------------------
  // 🔥 YÜKLE
  // ------------------------------------------------------
  Future<void> loadPermissions() async {
    await _loadNotificationPermission();
    await _loadLocationPermission();
    notifyListeners();
  }

  // ------------------------------------------------------
  // 🔥 Bildirim izni -> permission_handler İLE kontrol edilir
  // ------------------------------------------------------
  Future<void> _loadNotificationPermission() async {
    final notifStatus = await Permission.notification.status;

    notificationsAllowed = notifStatus.isGranted;
    notificationsPermanentlyDenied = notifStatus.isPermanentlyDenied;
  }

  // ------------------------------------------------------
  // 🔥 Konum izni kontrolü
  // ------------------------------------------------------
  Future<void> _loadLocationPermission() async {
    final locStatus = await Permission.location.status;

    locationAllowed = locStatus.isGranted;
    locationPermanentlyDenied = locStatus.isPermanentlyDenied;
  }

  // ------------------------------------------------------
  // 🔥 Bildirim izni isteme
  // ------------------------------------------------------
  Future<void> requestNotification() async {
    openAppSettings();

    // permission_handler ile kontrolü güncelliyoruz
    await _loadNotificationPermission();
    notifyListeners();
  }

  // ------------------------------------------------------
  // 🔥 Konum izni isteme
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
