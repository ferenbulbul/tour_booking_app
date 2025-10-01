// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_init_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentInitResponseImpl _$$PaymentInitResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentInitResponseImpl(
  conversationId: json['conversationId'] as String,
  token: json['token'] as String,
  paymentPageUrl: json['paymentPageUrl'] as String,
  tokenExpireTime: (json['tokenExpireTime'] as num?)?.toInt(),
);

Map<String, dynamic> _$$PaymentInitResponseImplToJson(
  _$PaymentInitResponseImpl instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'token': instance.token,
  'paymentPageUrl': instance.paymentPageUrl,
  'tokenExpireTime': instance.tokenExpireTime,
};
