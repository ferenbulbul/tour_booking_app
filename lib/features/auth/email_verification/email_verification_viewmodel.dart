import 'dart:async';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class EmailVerificationViewModel extends BaseViewModel {
  final AuthService _authService = ServiceLocator.instance.authService;

  String? message;
  String? errorMessage;

  int _resendCooldown = 0;
  int get resendCooldown => _resendCooldown;

  Timer? _resendTimer;

  Future<void> initializeVerification() async {
    final result = await _authService.resendVerificationCode();
    if (result.isSuccess == true) {
      message = result.message;
      errorMessage = null;
      startResendTimer();
    } else {
      errorMessage = result.message;
      message = null;
    }
    notifyListeners();
  }

  Future<void> resendCode() async {
    final result = await _authService.resendVerificationCode();
    if (result.isSuccess == true) {
      message = result.message;
      errorMessage = null;
      startResendTimer();
    } else {
      errorMessage = result.message;
      message = null;
    }
    notifyListeners();
  }

  Future<bool> verifyCode(String code) async {
    final result = await _authService.verifyCode(code);

    if (result.isSuccess == true) {
      message = result.message;
      errorMessage = null;
      notifyListeners();
      return true;
    } else {
      errorMessage = result.message;
      message = null;
      notifyListeners();
      return false;
    }
  }

  void startResendTimer() {
    _resendCooldown = 180;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCooldown--;

      notifyListeners(); // Required for UI update

      if (_resendCooldown <= 0) {
        _resendTimer?.cancel();
      }
    });
  }

  void clearMessages() {
    message = null;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
