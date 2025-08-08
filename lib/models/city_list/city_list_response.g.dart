// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileCityListResponseImpl _$$MobileCityListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MobileCityListResponseImpl(
  cities: (json['cityList'] as List<dynamic>)
      .map((e) => MobileCityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MobileCityListResponseImplToJson(
  _$MobileCityListResponseImpl instance,
) => <String, dynamic>{
  'cityList': instance.cities.map((e) => e.toJson()).toList(),
};
