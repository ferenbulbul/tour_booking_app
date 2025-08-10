// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DistrictDtoImpl _$$DistrictDtoImplFromJson(Map<String, dynamic> json) =>
    _$DistrictDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cityId: json['cityId'] as String,
    );

Map<String, dynamic> _$$DistrictDtoImplToJson(_$DistrictDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cityId': instance.cityId,
    };
