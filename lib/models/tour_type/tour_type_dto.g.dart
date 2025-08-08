// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourTypeDtoImpl _$$TourTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$TourTypeDtoImpl(
      id: json['id'] as String,
      mainImageUrl: json['mainImageUrl'] as String,
      thumbImageUrl: json['thumbImageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$TourTypeDtoImplToJson(_$TourTypeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mainImageUrl': instance.mainImageUrl,
      'thumbImageUrl': instance.thumbImageUrl,
      'title': instance.title,
      'description': instance.description,
    };
