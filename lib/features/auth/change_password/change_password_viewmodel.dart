import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final AuthService _authService = ServiceLocator.instance.authService;

  bool isLoading = false;
  String? message; // error/message
  List<String> validationErrors = [];

  Future<Result<void>> changePassword(String password) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.changePassword(password);
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
