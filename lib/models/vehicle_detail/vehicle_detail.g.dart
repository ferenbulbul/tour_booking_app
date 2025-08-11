// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleDetailImpl _$$VehicleDetailImplFromJson(Map<String, dynamic> json) =>
    _$VehicleDetailImpl(
      vehicleId: json['vehicleId'] as String?,
      price: (json['price'] as num?)?.toInt(),
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleClass: json['vehicleClass'] as String,
      vehicleType: json['vehicleType'] as String,
      seatCount: (json['seatCount'] as num).toInt(),
      image: json['image'] as String,
      legRoomSpace: json['legRoomSpace'] as String?,
      seatType: json['seatType'] as String?,
      modelYear: (json['modelYear'] as num?)?.toInt(),
      otherImages: (json['otherImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vehicleFeatures: (json['vehicleFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$VehicleDetailImplToJson(_$VehicleDetailImpl instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'price': instance.price,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleClass': instance.vehicleClass,
      'vehicleType': instance.vehicleType,
      'seatCount': instance.seatCount,
      'image': instance.image,
      'legRoomSpace': instance.legRoomSpace,
      'seatType': instance.seatType,
      'modelYear': instance.modelYear,
      'otherImages': instance.otherImages,
      'vehicleFeatures': instance.vehicleFeatures,
    };
