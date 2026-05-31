import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/profile/profile_response.dart';
import 'package:tour_booking/models/update_phone_number/update_phone_request.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileResponse? _profile;
  bool isLoading = false;
  String? message;
  String? _updatingPreference;

  ProfileResponse? get profile => _profile;
  String? get updatingPreference => _updatingPreference;

  void clear() {
    _profile = null;
    isLoading = false;
    message = null;
    notifyListeners();
  }

  final TourService _tourService = ServiceLocator.instance.tourService;
  final AuthService _authService = ServiceLocator.instance.authService;

  Future<void> fetchProfile() async {
    isLoading = true;
    message = null;
    notifyListeners();

    final result = await _tourService.getProfile();

    if (result.isSuccess ?? false) {
      _profile = result.data;
    } else {
      message = result.message;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePhoneNumber(UpdatePhoneRequestDto request) async {
    if (_profile == null) return false;

    isLoading = true;
    notifyListeners();

    final result = await _tourService.updatePhoneNumber(request);

    bool success = false;
    if (result.isSuccess ?? false) {
      await fetchProfile();
      message = null;
      success = true;
    } else {
      message = result.message ?? tr('phone_update_failed');
    }

    isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();

    // final result = await _tourService.changePassword(oldPassword, newPassword);

    // if (result.isSuccess ?? false) {
    //   message = "Password changed successfully";
    // } else {
    //   message = result.message ?? "Failed to change password";
    // }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyCode(String code) async {
    final result = await _authService.verifyCode(code);

    if (result.isSuccess == true) {
      message = result.message;
      notifyListeners();
      return true;
    } else {
      message = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateNotificationPreference({
    required String type,
    required bool value,
  }) async {
    if (_profile == null) return;

    final oldProfile = _profile!;

    _profile = _profile!.copyWith(
      emailNotification: type == 'email' ? value : _profile!.emailNotification,
      pushNotification: type == 'push' ? value : _profile!.pushNotification,
      smsNotification: type == 'sms' ? value : _profile!.smsNotification,
    );
    _updatingPreference = type;
    notifyListeners();

    final result = await _tourService.updateNotificationPreferences(
      emailNotification: _profile!.emailNotification,
      pushNotification: _profile!.pushNotification,
      smsNotification: _profile!.smsNotification,
    );

    if (!(result.isSuccess ?? false)) {
      _profile = oldProfile;
      message = result.message;
    }

    _updatingPreference = null;
    notifyListeners();
  }

  Future<bool> deleteAccount() async {
    isLoading = true;
    message = null;
    notifyListeners();

    // OneSignal logout (disconnect push binding)
    try {
      await OneSignal.logout();
    } catch (e) {
      debugPrint('ProfileViewModel.deleteAccount: $e');
    }

    final result = await _authService.deleteAccount();

    isLoading = false;
    message = result.message;

    notifyListeners();

    return result.isSuccess == true;
  }
}
