// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleResponseImpl _$$VehicleResponseImplFromJson(
  Map<String, dynamic> json,
) => _$VehicleResponseImpl(
  vehicleDtos: json['vehicleDtos'] == null
      ? null
      : VehicleDetail.fromJson(json['vehicleDtos'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$VehicleResponseImplToJson(
  _$VehicleResponseImpl instance,
) => <String, dynamic>{'vehicleDtos': instance.vehicleDtos?.toJson()};
