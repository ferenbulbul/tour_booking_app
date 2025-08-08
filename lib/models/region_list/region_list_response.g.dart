// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileRegionListResponseImpl _$$MobileRegionListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MobileRegionListResponseImpl(
  regions: (json['regionList'] as List<dynamic>)
      .map((e) => MobileRegionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MobileRegionListResponseImplToJson(
  _$MobileRegionListResponseImpl instance,
) => <String, dynamic>{
  'regionList': instance.regions.map((e) => e.toJson()).toList(),
};
