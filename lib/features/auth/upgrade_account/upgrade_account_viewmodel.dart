import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class UpgradeAccountViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];

  Future<Result<LoginResponse>> upgradeAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? countryCode,
  }) async {
    isLoading = true;
    message = null;
    validationErrors = [];
    notifyListeners();

    try {
      final response = await _authService.upgradeAccount(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      final result = handleResponse<LoginResponse>(response);

      if (result.isSuccess && result.data != null) {
        message = null;
        validationErrors = [];
      } else {
        message = result.error?.message;
        validationErrors = result.error?.validationErrors ?? [];
      }
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
