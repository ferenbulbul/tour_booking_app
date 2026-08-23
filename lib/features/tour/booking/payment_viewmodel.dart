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

  /// True when retries were exhausted without a terminal (Success/Fail) status.
  /// The charge may still complete server-side; reconciliation resolves it.
  bool isResultUnknown = false;

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

  /// Initialize checkout form.
  /// Banka güvenlik katmanı (WAF) istekleri pencereler halinde engelleyebiliyor;
  /// kullanıcıya hata göstermeden önce SESSİZCE tekrar denenir (toplam 3 tur,
  /// aralarda bekleme — sunucu da her turda içeride 4 deneme yapar). Kullanıcı
  /// bu süre boyunca yalnız yükleniyor durumunu görür.
  Future<void> initPayment(String bookingId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    const maxAttempts = 3;
    const retryDelay = Duration(seconds: 7);

    try {
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
          final req = PaymentRequest(bookingId: bookingId);
          final BaseResponse<PaymentInitResponse> resp = await _service
              .initCheckoutForm(req);

          if (resp.isSuccess == true && resp.data != null) {
            initData = resp.data;
            errorMessage = null;
            return;
          }
          errorMessage = resp.message ?? tr('error_generic');
        } catch (e) {
          errorMessage = tr('error_occurred', namedArgs: {'error': e.toString()});
        }

        if (attempt < maxAttempts) {
          await Future.delayed(retryDelay);
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Tek seferlik sonuç kontrolü — webview açıkken dönen arka plan polling'i için.
  /// Backend, Pending KT ödemesinde bankaya anlık inquiry atar; yani bu çağrı
  /// banka yönlendirmesi hiç gelmese bile sonucu yakalayabilir.
  /// Terminal duruma (Success/Fail) ulaşıldıysa true döner.
  Future<bool> checkPaymentResultOnce(String token) async {
    try {
      final BaseResponse<PaymentResultResponse> resp = await _service
          .getPaymentResult(token);
      if (resp.isSuccess == true && resp.data != null) {
        resultData = resp.data;
        if (resp.data!.paymentStatus != "Pending") {
          notifyListeners();
          return true;
        }
      }
    } catch (_) {
      // Geçici hata — sonraki tur tekrar dener.
    }
    return false;
  }

  /// Check payment result with retry.
  /// The backend may not have processed the iyzico callback yet when we first
  /// query, so we retry until a TERMINAL status (Success/Fail) is returned —
  /// a "Pending" response is not a result, it means "not processed yet".
  Future<void> checkPaymentResult(String token) async {
    errorMessage = null;
    isResultUnknown = false;

    const maxRetries = 8;
    const baseDelay = Duration(seconds: 2);
    const maxDelay = Duration(seconds: 10);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      // Wait before each attempt (including the first) to give the backend
      // time to process the iyzico callback. Delay grows but is capped.
      final delay = baseDelay * (attempt + 1);
      await Future.delayed(delay > maxDelay ? maxDelay : delay);

      try {
        final BaseResponse<PaymentResultResponse> resp = await _service
            .getPaymentResult(token);

        if (resp.isSuccess == true && resp.data != null) {
          resultData = resp.data;

          // Only stop on a terminal status; keep polling while Pending.
          if (resp.data!.paymentStatus != "Pending") {
            notifyListeners();
            return;
          }
        }
      } catch (_) {
        // Transient error — keep retrying until attempts run out.
      }
    }

    // Retries exhausted without a terminal status. Do NOT report this as a
    // failure: the charge may have gone through. Backend reconciliation will
    // finalize the booking; user is directed to My Reservations.
    isResultUnknown = true;
    notifyListeners();
  }
}
