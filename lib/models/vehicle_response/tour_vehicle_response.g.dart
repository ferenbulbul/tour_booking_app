// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourVehicleResponseImpl _$$TourVehicleResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TourVehicleResponseImpl(
  vehicles: (json['vehicles'] as List<dynamic>?)
      ?.map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TourVehicleResponseImplToJson(
  _$TourVehicleResponseImpl instance,
) => <String, dynamic>{
  'vehicles': instance.vehicles?.map((e) => e.toJson()).toList(),
};
