import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? message;
  String? errorMessage;
  bool isLoading = false;

  // 🔁 Geri sayım için
  int resendCooldown = 0;
  Timer? _cooldownTimer;

  // ✅ Kod gönderme (başlangıç)
  Future<Result<void>> forgotPassword(String email) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.forgotPassword(email);
    final result = handleResponse<void>(response);

    if (result.isSuccess) {
      message = response.message;
      startCooldown();
    } else {
      errorMessage = result.error?.message;
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  // ✅ Kod doğrulama
  Future<Result<void>> verifyPasswordCode(String email, String code) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.verifyPasswordCode(email, code);
    final result = handleResponse<void>(response);

    if (result.isSuccess) {
      message = null;
    } else {
      errorMessage = result.error?.message;
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  // ✅ Şifre sıfırlama
  Future<Result<void>> resetPassword(String email, String newPassword) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.resetPassword(email, newPassword);
    final result = handleResponse<void>(response);

    if (result.isSuccess) {
      message = response.message;
    } else {
      errorMessage = result.error?.message;
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  // ✅ Kod tekrar gönderme
  Future<void> resendResetCode(String email) async {
    if (resendCooldown > 0) return;

    isLoading = true;
    notifyListeners();

    final response = await _authService.forgotPassword(email);
    final result = handleResponse<void>(response);

    if (result.isSuccess) {
      message = 'Kod yeniden gönderildi';
      startCooldown();
    } else {
      errorMessage = result.error?.message;
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔄 Sayaç başlat
  void startCooldown() {
    _cooldownTimer?.cancel();
    resendCooldown = 180;

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown == 0) {
        timer.cancel();
      } else {
        resendCooldown--;
        notifyListeners();
      }
    });
  }

  void stopCooldown() {
    _cooldownTimer?.cancel();
  }

  // 🔄 Mesajları temizle
  void clearMessages() {
    message = null;
    errorMessage = null;
    notifyListeners();
  }
}
