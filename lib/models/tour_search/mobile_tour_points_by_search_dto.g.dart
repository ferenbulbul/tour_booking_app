// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_tour_points_by_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileTourPointsBySearchDtoImpl _$$MobileTourPointsBySearchDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MobileTourPointsBySearchDtoImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  image: json['image'] as String?,
  cityName: json['cityName'] as String?,
  cityId: json['cityId'] as String?,
  avgRating: (json['avgRating'] as num?)?.toDouble(),
  tourCount: (json['tourCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$$MobileTourPointsBySearchDtoImplToJson(
  _$MobileTourPointsBySearchDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'image': instance.image,
  'cityName': instance.cityName,
  'cityId': instance.cityId,
  'avgRating': instance.avgRating,
  'tourCount': instance.tourCount,
};
