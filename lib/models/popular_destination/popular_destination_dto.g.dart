// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_destination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PopularDestinationDtoImpl _$$PopularDestinationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PopularDestinationDtoImpl(
  id: json['id'] as String,
  cityId: json['cityId'] as String?,
  cityName: json['cityName'] as String?,
  districtId: json['districtId'] as String?,
  districtName: json['districtName'] as String?,
  imageUrl: json['imageUrl'] as String,
  displayOrder: (json['displayOrder'] as num).toInt(),
);

Map<String, dynamic> _$$PopularDestinationDtoImplToJson(
  _$PopularDestinationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cityId': instance.cityId,
  'cityName': instance.cityName,
  'districtId': instance.districtId,
  'districtName': instance.districtName,
  'imageUrl': instance.imageUrl,
  'displayOrder': instance.displayOrder,
};
