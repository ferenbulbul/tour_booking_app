// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourPointImpl _$$TourPointImplFromJson(Map<String, dynamic> json) =>
    _$TourPointImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      tourTypeId: json['tourTypeId'] as String,
      tourTypeName: json['tourTypeName'] as String,
      tourDifficultyId: json['tourDifficultyId'] as String,
      tourDifficultyName: json['tourDifficultyName'] as String,
      countryId: json['countryId'] as String,
      countryName: json['countryName'] as String,
      regionId: json['regionId'] as String,
      regionName: json['regionName'] as String,
      cityId: json['cityId'] as String,
      cityName: json['cityName'] as String,
      districtId: json['districtId'] as String,
      districtName: json['districtName'] as String,
      mainImage: json['mainImage'] as String,
      otherImages: (json['otherImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TourPointImplToJson(_$TourPointImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tourTypeId': instance.tourTypeId,
      'tourTypeName': instance.tourTypeName,
      'tourDifficultyId': instance.tourDifficultyId,
      'tourDifficultyName': instance.tourDifficultyName,
      'countryId': instance.countryId,
      'countryName': instance.countryName,
      'regionId': instance.regionId,
      'regionName': instance.regionName,
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'districtId': instance.districtId,
      'districtName': instance.districtName,
      'mainImage': instance.mainImage,
      'otherImages': instance.otherImages,
    };
