import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class VerifyPhoneViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();
  bool isLoading = false;
  String? message;

  int _remainingSeconds = 180; // 3 dakika
  int get remainingSeconds => _remainingSeconds;
  bool get canResend => _remainingSeconds == 0;

  Timer? _timer;

  Future<void> sendCode() async {
    isLoading = true;
    notifyListeners();

    final result = await _tourService.sendVerificationCode();

    if (result.isSuccess ?? false) {
      message = result.message ?? "Doğrulama kodu gönderildi.";
      _startTimer();
    } else {
      message = result.message ?? "Kod gönderilemedi.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> verifyCode(String code) async {
    isLoading = true;
    notifyListeners();

    final result = await _tourService.verifyCode(code);

    isLoading = false;
    notifyListeners();

    if (result.isSuccess ?? false) {
      message = result.message ?? "Kod başarıyla doğrulandı";
      return true;
    } else {
      message = result.message ?? "Kod doğrulama başarısız.";
      return false;
    }
  }

  void _startTimer() {
    _remainingSeconds = 180;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        _remainingSeconds--;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
