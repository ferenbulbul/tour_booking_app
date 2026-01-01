// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDtoImpl _$$BookingDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingDtoImpl(
      id: json['id'] as String,
      tourPointName: json['tourPointName'] as String,
      tourPointCity: json['tourPointCity'] as String,
      tourPointDistrict: json['tourPointDistrict'] as String,
      departureTime: json['departureTime'] as String,
      driverName: json['driverName'] as String,
      tourPointPrice: json['tourPointPrice'] as num,
      guideName: json['guideName'] as String,
      guidePrice: json['guidePrice'] as num,
      totalPrice: json['totalPrice'] as num,
      vehicleBrand: json['vehicleBrand'] as String,
      seatCount: (json['seatCount'] as num).toInt(),
      departureLocationDescription:
          json['departureLocationDescription'] as String,
      departureCity: json['departureCity'] as String,
      departureDistrict: json['departureDistrict'] as String,
      departureDate: json['departureDate'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$BookingDtoImplToJson(_$BookingDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
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
    };
