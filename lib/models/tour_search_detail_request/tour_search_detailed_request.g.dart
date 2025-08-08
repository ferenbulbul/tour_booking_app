// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_search_detailed_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourSearchRequestImpl _$$TourSearchRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TourSearchRequestImpl(
  type: (json['type'] as num).toInt(),
  regionId: json['regionId'] as String?,
  cityId: json['cityId'] as String?,
  districtId: json['districtId'] as String?,
);

Map<String, dynamic> _$$TourSearchRequestImplToJson(
  _$TourSearchRequestImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'regionId': instance.regionId,
  'cityId': instance.cityId,
  'districtId': instance.districtId,
};
