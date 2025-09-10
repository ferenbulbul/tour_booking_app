// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbyListResponseImpl _$$NearbyListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$NearbyListResponseImpl(
  nearByList: (json['nearByList'] as List<dynamic>)
      .map((e) => NearbyTourPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$NearbyListResponseImplToJson(
  _$NearbyListResponseImpl instance,
) => <String, dynamic>{
  'nearByList': instance.nearByList.map((e) => e.toJson()).toList(),
};
