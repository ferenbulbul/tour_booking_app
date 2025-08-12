// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_guide_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourGuideRequestImpl _$$TourGuideRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TourGuideRequestImpl(
  cityId: json['cityId'] as String,
  districtId: json['districtId'] as String,
  tourPointId: json['tourPointId'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$TourGuideRequestImplToJson(
  _$TourGuideRequestImpl instance,
) => <String, dynamic>{
  'cityId': instance.cityId,
  'districtId': instance.districtId,
  'tourPointId': instance.tourPointId,
  'date': _dateToString(instance.date),
};
