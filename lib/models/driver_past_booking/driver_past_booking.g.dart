// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_past_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverPastBookingImpl _$$DriverPastBookingImplFromJson(
  Map<String, dynamic> json,
) => _$DriverPastBookingImpl(
  id: json['id'] as String,
  customerName: json['customerName'] as String? ?? '',
  tourPointName: json['tourPointName'] as String? ?? '',
  departureDate: json['departureDate'] as String? ?? '',
  departureTime: json['departureTime'] as String? ?? '',
  totalPrice: json['totalPrice'] as num? ?? 0,
  status: json['status'] as String? ?? '',
  bookingType: (json['bookingType'] as num?)?.toInt() ?? 0,
  pickupAddress: json['pickupAddress'] as String?,
  dropoffAddress: json['dropoffAddress'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  ratingComment: json['ratingComment'] as String?,
);

Map<String, dynamic> _$$DriverPastBookingImplToJson(
  _$DriverPastBookingImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerName': instance.customerName,
  'tourPointName': instance.tourPointName,
  'departureDate': instance.departureDate,
  'departureTime': instance.departureTime,
  'totalPrice': instance.totalPrice,
  'status': instance.status,
  'bookingType': instance.bookingType,
  'pickupAddress': instance.pickupAddress,
  'dropoffAddress': instance.dropoffAddress,
  'rating': instance.rating,
  'ratingComment': instance.ratingComment,
};
