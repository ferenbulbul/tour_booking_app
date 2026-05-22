import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/failure_model.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService = ServiceLocator.instance.authService;

  String? message;
  List<String> validationErrors = [];
  bool isLoading = false;
  LoginResponse? loggedInUser;

  Future<Result<LoginResponse>> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);
      final result = handleResponse<LoginResponse>(response);

      if (result.isSuccess) {
        message = null;
        validationErrors = [];
        loggedInUser = result.data;
      } else {
        message = result.error?.message;
        validationErrors = result.error?.validationErrors ?? [];
      }

      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('LoginViewModel.login: $e');
      message = tr('error_generic');
      validationErrors = [];
      isLoading = false;
      notifyListeners();
      return Result.failure(FailureModel(message: message!));
    }
  }
}
