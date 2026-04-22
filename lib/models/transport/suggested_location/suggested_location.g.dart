// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestedLocationTranslationImpl _$$SuggestedLocationTranslationImplFromJson(
  Map<String, dynamic> json,
) => _$SuggestedLocationTranslationImpl(
  languageCode: json['languageCode'] as String?,
  name: json['name'] as String? ?? '',
  description: json['description'] as String?,
);

Map<String, dynamic> _$$SuggestedLocationTranslationImplToJson(
  _$SuggestedLocationTranslationImpl instance,
) => <String, dynamic>{
  'languageCode': instance.languageCode,
  'name': instance.name,
  'description': instance.description,
};

_$TransportSuggestedLocationImpl _$$TransportSuggestedLocationImplFromJson(
  Map<String, dynamic> json,
) => _$TransportSuggestedLocationImpl(
  id: json['id'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  cityId: json['cityId'] as String,
  districtId: json['districtId'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  translations:
      (json['translations'] as List<dynamic>?)
          ?.map(
            (e) => SuggestedLocationTranslation.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TransportSuggestedLocationImplToJson(
  _$TransportSuggestedLocationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'cityId': instance.cityId,
  'districtId': instance.districtId,
  'isActive': instance.isActive,
  'translations': instance.translations.map((e) => e.toJson()).toList(),
};
