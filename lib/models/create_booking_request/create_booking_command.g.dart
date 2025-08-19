// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_booking_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateBookingCommandImpl _$$CreateBookingCommandImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBookingCommandImpl(
  tourPointId: json['tourPointId'] as String,
  guideId: json['guideId'] as String?,
  cityId: json['cityId'] as String,
  districtId: json['districtId'] as String,
  vehicleId: json['vehicleId'] as String,
  tourPrice: const DecimalConverter().fromJson(json['tourPrice']),
  guidePrice: const DecimalConverter().fromJson(json['guidePrice']),
  Latitude: (json['Latitude'] as num?)?.toDouble(),
  Longitude: (json['Longitude'] as num?)?.toDouble(),
  LocationDescription: json['LocationDescription'] as String?,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$CreateBookingCommandImplToJson(
  _$CreateBookingCommandImpl instance,
) => <String, dynamic>{
  'tourPointId': instance.tourPointId,
  'guideId': instance.guideId,
  'cityId': instance.cityId,
  'districtId': instance.districtId,
  'vehicleId': instance.vehicleId,
  'tourPrice': const DecimalConverter().toJson(instance.tourPrice),
  'guidePrice': _$JsonConverterToJson<dynamic, Decimal>(
    instance.guidePrice,
    const DecimalConverter().toJson,
  ),
  'Latitude': instance.Latitude,
  'Longitude': instance.Longitude,
  'LocationDescription': instance.LocationDescription,
  'date': _dateToString(instance.date),
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
