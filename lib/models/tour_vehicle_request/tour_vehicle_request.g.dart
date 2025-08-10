// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_vehicle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourVehicleRequestImpl _$$TourVehicleRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TourVehicleRequestImpl(
  cityId: json['cityId'] as String,
  districtId: json['districtId'] as String,
  tourPointId: json['tourPointId'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$TourVehicleRequestImplToJson(
  _$TourVehicleRequestImpl instance,
) => <String, dynamic>{
  'cityId': instance.cityId,
  'districtId': instance.districtId,
  'tourPointId': instance.tourPointId,
  'date': _dateToString(instance.date),
};
