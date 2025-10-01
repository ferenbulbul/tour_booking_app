import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/payment_init_response/payment_init_response.dart';
import 'package:tour_booking/models/payment_request/payment_request.dart';
import 'package:tour_booking/models/payment_result_response/payment_result_response.dart';
import 'package:tour_booking/services/core/api_client.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<PaymentInitResponse>> initCheckoutForm(
    PaymentRequest req,
  ) async {
    // http.post ile backend /cf-init çağır
    // response -> PaymentInitResponse.fromJson(json)
    var response = _apiClient.post<PaymentInitResponse>(
      path: "/Payments/cf-init",
      body: req.toJson(),
      fromJson: (json) =>
          PaymentInitResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<PaymentResultResponse>> getPaymentResult(
    String token,
  ) async {
    // http.get ile backend /result/{conversationId}
    // response -> PaymentResultResponse.fromJson(json)
    var response = _apiClient.get<PaymentResultResponse>(
      path: "/Payments/result",
      queryParams: {"token": token},
      fromJson: (json) =>
          PaymentResultResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }
}
