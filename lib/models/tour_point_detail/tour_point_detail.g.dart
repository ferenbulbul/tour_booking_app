// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_point_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourPointDetailImpl _$$TourPointDetailImplFromJson(
  Map<String, dynamic> json,
) => _$TourPointDetailImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  mainImage: json['mainImage'] as String,
  otherImages: (json['otherImages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  cityName: json['cityName'] as String,
  districtName: json['districtName'] as String,
  regionName: json['regionName'] as String,
  countryName: json['countryName'] as String,
  tourTypeName: json['tourTypeName'] as String,
  tourDifficultyName: json['tourDifficultyName'] as String,
  cities: (json['cities'] as List<dynamic>)
      .map((e) => CityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  districts: (json['districts'] as List<dynamic>)
      .map((e) => DistrictDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  isFavorites: json['isFavorites'] as bool,
  avgRating: (json['avgRating'] as num?)?.toDouble(),
  ratingCount: (json['ratingCount'] as num?)?.toInt(),
  shortDescription: json['shortDescription'] as String?,
  durationHours: (json['durationHours'] as num?)?.toInt() ?? 0,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
  routePoints:
      (json['routePoints'] as List<dynamic>?)
          ?.map((e) => RoutePointItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  highlights:
      (json['highlights'] as List<dynamic>?)
          ?.map((e) => HighlightItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  inclusions:
      (json['inclusions'] as List<dynamic>?)
          ?.map((e) => InclusionItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  importantInfos:
      (json['importantInfos'] as List<dynamic>?)
          ?.map((e) => ImportantInfoItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TourPointDetailImplToJson(
  _$TourPointDetailImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'mainImage': instance.mainImage,
  'otherImages': instance.otherImages,
  'cityName': instance.cityName,
  'districtName': instance.districtName,
  'regionName': instance.regionName,
  'countryName': instance.countryName,
  'tourTypeName': instance.tourTypeName,
  'tourDifficultyName': instance.tourDifficultyName,
  'cities': instance.cities.map((e) => e.toJson()).toList(),
  'districts': instance.districts.map((e) => e.toJson()).toList(),
  'isFavorites': instance.isFavorites,
  'avgRating': instance.avgRating,
  'ratingCount': instance.ratingCount,
  'shortDescription': instance.shortDescription,
  'durationHours': instance.durationHours,
  'durationMinutes': instance.durationMinutes,
  'routePoints': instance.routePoints.map((e) => e.toJson()).toList(),
  'highlights': instance.highlights.map((e) => e.toJson()).toList(),
  'inclusions': instance.inclusions.map((e) => e.toJson()).toList(),
  'importantInfos': instance.importantInfos.map((e) => e.toJson()).toList(),
};
