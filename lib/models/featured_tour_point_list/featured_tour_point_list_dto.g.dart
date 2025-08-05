// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_tour_point_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeaturedTourPointListDtoImpl _$$FeaturedTourPointListDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FeaturedTourPointListDtoImpl(
  tourPoints: (json['tourPoints'] as List<dynamic>)
      .map((e) => FeaturedTourPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$FeaturedTourPointListDtoImplToJson(
  _$FeaturedTourPointListDtoImpl instance,
) => <String, dynamic>{
  'tourPoints': instance.tourPoints.map((e) => e.toJson()).toList(),
};
