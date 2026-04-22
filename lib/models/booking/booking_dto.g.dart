// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDtoImpl _$$BookingDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingDtoImpl(
      id: json['id'] as String,
      image: json['image'] as String? ?? '',
      tourPointName: json['tourPointName'] as String? ?? '',
      tourPointCity: json['tourPointCity'] as String? ?? '',
      tourPointDistrict: json['tourPointDistrict'] as String? ?? '',
      departureTime: json['departureTime'] as String? ?? '',
      driverName: json['driverName'] as String? ?? '',
      tourPointPrice: json['tourPointPrice'] as num? ?? 0,
      guideName: json['guideName'] as String? ?? '',
      guidePrice: json['guidePrice'] as num? ?? 0,
      totalPrice: json['totalPrice'] as num? ?? 0,
      vehicleBrand: json['vehicleBrand'] as String? ?? '',
      seatCount: (json['seatCount'] as num?)?.toInt() ?? 0,
      departureLocationDescription:
          json['departureLocationDescription'] as String? ?? '',
      departureCity: json['departureCity'] as String? ?? '',
      departureDistrict: json['departureDistrict'] as String? ?? '',
      departureDate: json['departureDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      canRate: json['canRate'] as bool?,
      ratingRequestId: json['ratingRequestId'] as String?,
      ratingToken: json['ratingToken'] as String?,
      bookingType: (json['bookingType'] as num?)?.toInt() ?? 0,
      pickupAddress: json['pickupAddress'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      pickupTime: json['pickupTime'] as String?,
    );

Map<String, dynamic> _$$BookingDtoImplToJson(_$BookingDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'tourPointName': instance.tourPointName,
      'tourPointCity': instance.tourPointCity,
      'tourPointDistrict': instance.tourPointDistrict,
      'departureTime': instance.departureTime,
      'driverName': instance.driverName,
      'tourPointPrice': instance.tourPointPrice,
      'guideName': instance.guideName,
      'guidePrice': instance.guidePrice,
      'totalPrice': instance.totalPrice,
      'vehicleBrand': instance.vehicleBrand,
      'seatCount': instance.seatCount,
      'departureLocationDescription': instance.departureLocationDescription,
      'departureCity': instance.departureCity,
      'departureDistrict': instance.departureDistrict,
      'departureDate': instance.departureDate,
      'status': instance.status,
      'canRate': instance.canRate,
      'ratingRequestId': instance.ratingRequestId,
      'ratingToken': instance.ratingToken,
      'bookingType': instance.bookingType,
      'pickupAddress': instance.pickupAddress,
      'dropoffAddress': instance.dropoffAddress,
      'distanceKm': instance.distanceKm,
      'pickupTime': instance.pickupTime,
    };
