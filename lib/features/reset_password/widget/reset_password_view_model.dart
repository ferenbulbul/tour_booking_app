import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/reset_password/reset_password_request.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();
  String? errorMessage;
  String? message;
  List<String> validationErrors = [];
  bool isLoading = false;
  bool resultss = false;

  Future<Result<void>> resetPassword(
    String email,
    String token,
    String newPassword,
  ) async {
    isLoading = true;
    notifyListeners();

    final req = ResetPasswordRequest(
      email: email,
      token: token,
      newPassword: newPassword,
    );
    final response = await _auth.resetPassword(req);

    final result = handleResponse<void>(response);

    if (result.isSuccess) {
      message = response.message;
      validationErrors = [];
      errorMessage = null;
      resultss = true;
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
    errorMessage = null;
    notifyListeners();
  }
}
