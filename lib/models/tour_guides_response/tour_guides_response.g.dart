// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_guides_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourGuidesResponseImpl _$$TourGuidesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TourGuidesResponseImpl(
  guides:
      (json['guides'] as List<dynamic>?)
          ?.map((e) => Guide.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Guide>[],
);

Map<String, dynamic> _$$TourGuidesResponseImplToJson(
  _$TourGuidesResponseImpl instance,
) => <String, dynamic>{
  'guides': instance.guides.map((e) => e.toJson()).toList(),
};
