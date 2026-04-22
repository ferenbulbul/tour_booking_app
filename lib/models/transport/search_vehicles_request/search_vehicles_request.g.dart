// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_vehicles_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportSearchVehiclesRequestImpl
_$$TransportSearchVehiclesRequestImplFromJson(Map<String, dynamic> json) =>
    _$TransportSearchVehiclesRequestImpl(
      cityId: json['cityId'] as String,
      districtId: json['districtId'] as String?,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$$TransportSearchVehiclesRequestImplToJson(
  _$TransportSearchVehiclesRequestImpl instance,
) => <String, dynamic>{
  'cityId': instance.cityId,
  'districtId': instance.districtId,
  'date': _dateToString(instance.date),
  'startTime': instance.startTime,
  'estimatedDurationMinutes': instance.estimatedDurationMinutes,
};
