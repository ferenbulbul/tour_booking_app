import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_init_response.freezed.dart';
part 'payment_init_response.g.dart';

@freezed
class PaymentInitResponse with _$PaymentInitResponse {
  const factory PaymentInitResponse({
    required String conversationId,
    required String token,
    required String paymentPageUrl,
    int? tokenExpireTime,
  }) = _PaymentInitResponse;

  factory PaymentInitResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitResponseFromJson(json);
}
