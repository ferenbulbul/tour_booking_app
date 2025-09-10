// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_tour_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbyTourPointDtoImpl _$$NearbyTourPointDtoImplFromJson(
  Map<String, dynamic> json,
) => _$NearbyTourPointDtoImpl(
  id: json['id'] as String,
  cityName: json['cityName'] as String,
  tourTypeName: json['tourTypeName'] as String,
  title: json['title'] as String,
  mainImage: json['mainImage'] as String,
  distance: (json['distance'] as num).toDouble(),
);

Map<String, dynamic> _$$NearbyTourPointDtoImplToJson(
  _$NearbyTourPointDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cityName': instance.cityName,
  'tourTypeName': instance.tourTypeName,
  'title': instance.title,
  'mainImage': instance.mainImage,
  'distance': instance.distance,
};
