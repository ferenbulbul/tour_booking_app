// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_price_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportCalculatePriceRequestImpl
_$$TransportCalculatePriceRequestImplFromJson(Map<String, dynamic> json) =>
    _$TransportCalculatePriceRequestImpl(
      transportPricingId: json['transportPricingId'] as String,
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      dropoffLatitude: (json['dropoffLatitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num).toDouble(),
      clientDistanceKm: (json['clientDistanceKm'] as num?)?.toDouble(),
      clientDurationMinutes: (json['clientDurationMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TransportCalculatePriceRequestImplToJson(
  _$TransportCalculatePriceRequestImpl instance,
) => <String, dynamic>{
  'transportPricingId': instance.transportPricingId,
  'pickupLatitude': instance.pickupLatitude,
  'pickupLongitude': instance.pickupLongitude,
  'dropoffLatitude': instance.dropoffLatitude,
  'dropoffLongitude': instance.dropoffLongitude,
  'clientDistanceKm': instance.clientDistanceKm,
  'clientDurationMinutes': instance.clientDurationMinutes,
};
