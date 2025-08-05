// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_tour_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeaturedTourPointDtoImpl _$$FeaturedTourPointDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FeaturedTourPointDtoImpl(
  id: json['id'] as String,
  cityId: json['cityId'] as String,
  cityName: json['cityName'] as String,
  countryId: json['countryId'] as String,
  countryName: json['countryName'] as String,
  regionId: json['regionId'] as String,
  regionName: json['regionName'] as String,
  tourTypeId: json['tourTypeId'] as String,
  tourTypeName: json['tourTypeName'] as String,
  mainImage: json['mainImage'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$$FeaturedTourPointDtoImplToJson(
  _$FeaturedTourPointDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cityId': instance.cityId,
  'cityName': instance.cityName,
  'countryId': instance.countryId,
  'countryName': instance.countryName,
  'regionId': instance.regionId,
  'regionName': instance.regionName,
  'tourTypeId': instance.tourTypeId,
  'tourTypeName': instance.tourTypeName,
  'mainImage': instance.mainImage,
  'title': instance.title,
  'description': instance.description,
};
