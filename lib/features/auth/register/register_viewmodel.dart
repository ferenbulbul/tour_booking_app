import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthService _authService = ServiceLocator.instance.authService;

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];

  Future<Result<LoginResponse>> register(RegisterRequest request) async {
    isLoading = true;
    message = null;
    validationErrors = [];
    notifyListeners();

    try {
      final response = await _authService.register(request);
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
