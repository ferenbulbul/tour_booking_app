import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/payment_request/payment_request.dart';
import 'package:tour_booking/models/payment_init_response/payment_init_response.dart';
import 'package:tour_booking/models/payment_result_response/payment_result_response.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/payment/payment_service.dart';

class PaymentViewModel extends BaseViewModel {
  final PaymentService _service = ServiceLocator.instance.paymentService;

  bool isLoading = false;
  String? errorMessage;

  PaymentInitResponse? initData;
  PaymentResultResponse? resultData;

  bool isPageFinished = false;
  bool isCheckingPayment = false;

  void setPageFinished() {
    if (!isPageFinished) {
      isPageFinished = true;
      notifyListeners();
    }
  }

  void setCheckingPayment(bool value) {
    isCheckingPayment = value;
    notifyListeners();
  }

  /// Initialize checkout form
  Future<void> initPayment(String bookingId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final req = PaymentRequest(bookingId: bookingId);
      final BaseResponse<PaymentInitResponse> resp = await _service
          .initCheckoutForm(req);

      if (resp.isSuccess == true && resp.data != null) {
        initData = resp.data;
      } else {
        errorMessage = resp.message ?? tr('error_generic');
      }
    } catch (e) {
      errorMessage = tr('error_occurred', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Check payment result with retry.
  /// The backend may not have processed the iyzico callback yet when we first
  /// query, so we retry a few times with increasing delays.
  Future<void> checkPaymentResult(String token) async {
    errorMessage = null;

    const maxRetries = 5;
    const baseDelay = Duration(seconds: 2);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      // Wait before each attempt (including the first) to give the backend
      // time to process the iyzico callback.
      await Future.delayed(baseDelay * (attempt + 1));

      try {
        final BaseResponse<PaymentResultResponse> resp =
            await _service.getPaymentResult(token);

        if (resp.isSuccess == true && resp.data != null) {
          resultData = resp.data;
          notifyListeners();
          return; // Success — stop retrying.
        }

        // Last attempt — report the error.
        if (attempt == maxRetries - 1) {
          errorMessage = resp.message ?? tr('error_payment_result_failed');
        }
      } catch (e) {
        if (attempt == maxRetries - 1) {
          errorMessage =
              tr('error_result', namedArgs: {'error': e.toString()});
        }
      }
    }

    notifyListeners();
  }
}
