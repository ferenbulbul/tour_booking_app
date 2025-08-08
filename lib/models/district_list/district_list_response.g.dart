// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileDistrictListResponseImpl _$$MobileDistrictListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MobileDistrictListResponseImpl(
  districts: (json['districtList'] as List<dynamic>)
      .map((e) => MobileDistrictDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MobileDistrictListResponseImplToJson(
  _$MobileDistrictListResponseImpl instance,
) => <String, dynamic>{
  'districtList': instance.districts.map((e) => e.toJson()).toList(),
};
