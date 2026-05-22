import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class VerifyPhoneViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;
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
      message = result.message ?? tr('verification_code_sent');
      _startTimer();
    } else {
      message = result.message ?? tr('verification_code_failed');
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
      message = result.message ?? tr('verification_success');
      return true;
    } else {
      message = result.message ?? tr('verification_failed');
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
