import 'package:flutter/material.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/payment_request/payment_request.dart';
import 'package:tour_booking/models/payment_init_response/payment_init_response.dart';
import 'package:tour_booking/models/payment_result_response/payment_result_response.dart';
import 'package:tour_booking/services/payment/payment_service.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService _service = PaymentService();

  bool isLoading = false;
  String? errorMessage;

  PaymentInitResponse? initData;
  PaymentResultResponse? resultData;

  /// Checkout form başlat
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
        errorMessage = resp.message ?? "Ödeme başlatılamadı";
      }
    } catch (e) {
      errorMessage = "InitPayment hata: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Ödeme sonucunu kontrol et
  Future<void> checkPaymentResult(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final BaseResponse<PaymentResultResponse> resp = await _service
          .getPaymentResult(token);

      if (resp.isSuccess == true && resp.data != null) {
        resultData = resp.data;
      } else {
        errorMessage = resp.message ?? "Ödeme sonucu alınamadı";
      }
    } catch (e) {
      errorMessage = "Sonuç hatası: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
