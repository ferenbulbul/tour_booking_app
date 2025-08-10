// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      vehicleId: json['vehicleId'] as String,
      price: (json['price'] as num).toInt(),
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleClass: json['vehicleClass'] as String,
      vehicleType: json['vehicleType'] as String,
      seatCount: (json['seatCount'] as num).toInt(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'price': instance.price,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleClass': instance.vehicleClass,
      'vehicleType': instance.vehicleType,
      'seatCount': instance.seatCount,
      'image': instance.image,
    };
