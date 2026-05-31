// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverVehicleImpl _$$DriverVehicleImplFromJson(Map<String, dynamic> json) =>
    _$DriverVehicleImpl(
      id: json['id'] as String,
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      plate: json['plate'] as String? ?? '',
      seatCount: (json['seatCount'] as num?)?.toInt() ?? 0,
      vehicleType: json['vehicleType'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      year: (json['year'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DriverVehicleImplToJson(_$DriverVehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'model': instance.model,
      'plate': instance.plate,
      'seatCount': instance.seatCount,
      'vehicleType': instance.vehicleType,
      'imageUrl': instance.imageUrl,
      'year': instance.year,
    };
