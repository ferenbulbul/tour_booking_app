// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourSearchResponseImpl _$$TourSearchResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TourSearchResponseImpl(
  tourPoints: (json['tourPoints'] as List<dynamic>?)
      ?.map((e) => TourPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TourSearchResponseImplToJson(
  _$TourSearchResponseImpl instance,
) => <String, dynamic>{
  'tourPoints': instance.tourPoints?.map((e) => e.toJson()).toList(),
};
