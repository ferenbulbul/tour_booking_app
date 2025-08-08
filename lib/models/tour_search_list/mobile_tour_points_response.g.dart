// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_tour_points_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileTourPointsResponseImpl _$$MobileTourPointsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MobileTourPointsResponseImpl(
  tourPoints: (json['tourPoints'] as List<dynamic>)
      .map(
        (e) => MobileTourPointsBySearchDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$$MobileTourPointsResponseImplToJson(
  _$MobileTourPointsResponseImpl instance,
) => <String, dynamic>{
  'tourPoints': instance.tourPoints.map((e) => e.toJson()).toList(),
};
