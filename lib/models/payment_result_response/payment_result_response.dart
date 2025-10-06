import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_result_response.freezed.dart';
part 'payment_result_response.g.dart';

@freezed
class PaymentResultResponse with _$PaymentResultResponse {
  const factory PaymentResultResponse({
    required String paymentStatus,
    required String bookingStatus, // SUCCESS / FAILURE
    String? conversationId,
  }) = _PaymentResultResponse;

  factory PaymentResultResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultResponseFromJson(json);
}
