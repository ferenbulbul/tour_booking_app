// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingListResponseImpl _$$BookingListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$BookingListResponseImpl(
  customerBookings: (json['customerBookings'] as List<dynamic>)
      .map((e) => BookingDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$BookingListResponseImplToJson(
  _$BookingListResponseImpl instance,
) => <String, dynamic>{
  'customerBookings': instance.customerBookings.map((e) => e.toJson()).toList(),
};
