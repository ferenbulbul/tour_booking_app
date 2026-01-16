import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/profile/profile_response.dart';
import 'package:tour_booking/models/tour_type/tour_type_dto.dart';
import 'package:tour_booking/models/update_phone_number/update_phone_request.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileResponse? _profile;
  bool isLoading = false;
  String? message;

  ProfileResponse? get profile => _profile;

  final TourService _tourService = TourService();
  final AuthService _authService = AuthService();

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

  Future<void> updatePhoneNumber(UpdatePhoneRequestDto request) async {
    if (_profile == null) return;

    isLoading = true;
    notifyListeners();

    final result = await _tourService.updatePhoneNumber(request);

    if (result.isSuccess ?? false) {
      await fetchProfile(); // güncel veriyi tekrar çek
      message = null;
    } else {
      message = result.message ?? "Telefon numarası güncellenemedi";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();

    // final result = await _tourService.changePassword(oldPassword, newPassword);

    // if (result.isSuccess ?? false) {
    //   message = "Şifre başarıyla değiştirildi";
    // } else {
    //   message = result.message ?? "Şifre değiştirilemedi";
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

  Future<bool> deleteAccount() async {
    isLoading = true;
    message = null;
    notifyListeners();

    // 🔹 OneSignal logout (push bağını kopar)
    try {
      await OneSignal.logout();
    } catch (_) {}

    final result = await _authService.deleteAccount();

    isLoading = false;
    message = result.message;

    notifyListeners();

    return result.isSuccess == true;
  }
}
