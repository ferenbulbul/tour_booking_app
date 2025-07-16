import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? message;
  List<String> validationErrors = [];
  bool isLoading = false;

  Future<Result<LoginResponse>> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final request = LoginRequest(email: email, password: password);
    final response = await _authService.login(request);
    final SecureTokenStorage _tokenStorage = SecureTokenStorage();
    final result = handleResponse<LoginResponse>(response);

    if (result.isSuccess) {
      message = null;
      validationErrors = [];
      final token = result.data!.accessToken;
      final refresh = result.data!.refreshToken;

      await _tokenStorage.saveTokens(token, refresh);
    } else {
      message = result.error?.message;
      validationErrors = result.error?.validationErrors ?? [];
    }

    isLoading = false;
    notifyListeners();
    return result;
  }
}
