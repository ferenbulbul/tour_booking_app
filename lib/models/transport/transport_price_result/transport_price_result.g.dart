// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_price_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportPriceResultImpl _$$TransportPriceResultImplFromJson(
  Map<String, dynamic> json,
) => _$TransportPriceResultImpl(
  distanceKm: (json['distanceKm'] as num).toDouble(),
  estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num).toInt(),
  baseFee: json['baseFee'] as num,
  pricePerKm: json['pricePerKm'] as num,
  totalPrice: json['totalPrice'] as num,
  currency: json['currency'] as String? ?? 'TRY',
);

Map<String, dynamic> _$$TransportPriceResultImplToJson(
  _$TransportPriceResultImpl instance,
) => <String, dynamic>{
  'distanceKm': instance.distanceKm,
  'estimatedDurationMinutes': instance.estimatedDurationMinutes,
  'baseFee': instance.baseFee,
  'pricePerKm': instance.pricePerKm,
  'totalPrice': instance.totalPrice,
  'currency': instance.currency,
};
