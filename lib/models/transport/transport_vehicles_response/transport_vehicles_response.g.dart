// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportVehiclesResponseImpl _$$TransportVehiclesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TransportVehiclesResponseImpl(
  vehicles:
      (json['vehicles'] as List<dynamic>?)
          ?.map((e) => TransportVehicle.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TransportVehiclesResponseImplToJson(
  _$TransportVehiclesResponseImpl instance,
) => <String, dynamic>{
  'vehicles': instance.vehicles.map((e) => e.toJson()).toList(),
};
