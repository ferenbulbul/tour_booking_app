// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_types_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourTypesDtoImpl _$$TourTypesDtoImplFromJson(Map<String, dynamic> json) =>
    _$TourTypesDtoImpl(
      tourTypes: (json['tourTypes'] as List<dynamic>)
          .map((e) => TourTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TourTypesDtoImplToJson(_$TourTypesDtoImpl instance) =>
    <String, dynamic>{
      'tourTypes': instance.tourTypes.map((e) => e.toJson()).toList(),
    };
