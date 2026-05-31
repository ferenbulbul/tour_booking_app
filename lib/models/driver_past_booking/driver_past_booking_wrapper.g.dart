// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_past_booking_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverPastBookingWrapperImpl _$$DriverPastBookingWrapperImplFromJson(
  Map<String, dynamic> json,
) => _$DriverPastBookingWrapperImpl(
  bookings: (json['bookings'] as List<dynamic>)
      .map((e) => DriverPastBooking.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DriverPastBookingWrapperImplToJson(
  _$DriverPastBookingWrapperImpl instance,
) => <String, dynamic>{
  'bookings': instance.bookings.map((e) => e.toJson()).toList(),
};
