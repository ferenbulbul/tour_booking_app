// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentResultResponseImpl _$$PaymentResultResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentResultResponseImpl(
  paymentStatus: json['paymentStatus'] as String,
  bookingStatus: json['bookingStatus'] as String,
  conversationId: json['conversationId'] as String?,
);

Map<String, dynamic> _$$PaymentResultResponseImplToJson(
  _$PaymentResultResponseImpl instance,
) => <String, dynamic>{
  'paymentStatus': instance.paymentStatus,
  'bookingStatus': instance.bookingStatus,
  'conversationId': instance.conversationId,
};
