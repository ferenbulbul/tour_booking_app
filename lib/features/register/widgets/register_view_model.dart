import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/failure_model.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];

  Future<Result<LoginResponse>> register(RegisterRequest request) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.register(request);
    final SecureTokenStorage _tokenStorage = SecureTokenStorage();
    final result = handleResponse<LoginResponse>(response);

    if (result.isSuccess) {
      final loginResponse = result.data;
      if (loginResponse != null) {
        await _tokenStorage.saveTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );
      }
      message = null;
      validationErrors = [];
    } else {
      message = result.error?.message;
      validationErrors = result.error?.validationErrors ?? [];
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  void clearMessages() {
    message = null;
    validationErrors = [];
    notifyListeners();
  }
}
