import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? message; // hata/mesaj
  List<String> validationErrors = [];

  Future<Result<void>> changePassword(String password) async {
    isLoading = true;
    notifyListeners();

    // Servisin sadece string Password aldığı senaryoya göre:
    final response = await _authService.changePassword(password);

    // Backend'inin ApiResponse<T> => Result<T> dönüşümü
    final result = handleResponse<void>(response);

    if (result.isSuccess) {
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
}
