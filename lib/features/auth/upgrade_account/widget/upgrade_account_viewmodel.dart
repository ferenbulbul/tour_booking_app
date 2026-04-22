import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpgradeAccountViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

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
        final loginResponse = result.data!;

        // Tokenlari kaydet
        await _tokenStorage.saveTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );

        // SharedPreferences kayitlari
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', loginResponse.role);
        await prefs.setBool(
          'is_profile_complete',
          loginResponse.isProfileComplete,
        );

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
