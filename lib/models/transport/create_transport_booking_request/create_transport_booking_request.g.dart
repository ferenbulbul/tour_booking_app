// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transport_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTransportBookingRequestImpl
_$$CreateTransportBookingRequestImplFromJson(Map<String, dynamic> json) =>
    _$CreateTransportBookingRequestImpl(
      transportPricingId: json['transportPricingId'] as String,
      date: DateTime.parse(json['date'] as String),
      pickupTime: json['pickupTime'] as String,
      pickupAddress: json['pickupAddress'] as String,
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      dropoffAddress: json['dropoffAddress'] as String,
      dropoffLatitude: (json['dropoffLatitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num).toDouble(),
      buyerFirstName: json['buyerFirstName'] as String,
      buyerLastName: json['buyerLastName'] as String,
      buyerEmail: json['buyerEmail'] as String,
      buyerPhone: json['buyerPhone'] as String,
    );

Map<String, dynamic> _$$CreateTransportBookingRequestImplToJson(
  _$CreateTransportBookingRequestImpl instance,
) => <String, dynamic>{
  'transportPricingId': instance.transportPricingId,
  'date': _dateToString(instance.date),
  'pickupTime': instance.pickupTime,
  'pickupAddress': instance.pickupAddress,
  'pickupLatitude': instance.pickupLatitude,
  'pickupLongitude': instance.pickupLongitude,
  'dropoffAddress': instance.dropoffAddress,
  'dropoffLatitude': instance.dropoffLatitude,
  'dropoffLongitude': instance.dropoffLongitude,
  'buyerFirstName': instance.buyerFirstName,
  'buyerLastName': instance.buyerLastName,
  'buyerEmail': instance.buyerEmail,
  'buyerPhone': instance.buyerPhone,
};
