// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuideImpl _$$GuideImplFromJson(Map<String, dynamic> json) => _$GuideImpl(
  guideId: json['guideId'] as String,
  price: json['price'] as num,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$$GuideImplToJson(_$GuideImpl instance) =>
    <String, dynamic>{
      'guideId': instance.guideId,
      'price': instance.price,
      'languages': instance.languages,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
    };
