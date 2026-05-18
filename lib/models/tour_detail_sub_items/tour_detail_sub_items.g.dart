// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_detail_sub_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutePointItemImpl _$$RoutePointItemImplFromJson(Map<String, dynamic> json) =>
    _$RoutePointItemImpl(
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      orderIndex: (json['orderIndex'] as num).toInt(),
      pointType: (json['pointType'] as num).toInt(),
    );

Map<String, dynamic> _$$RoutePointItemImplToJson(
  _$RoutePointItemImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'orderIndex': instance.orderIndex,
  'pointType': instance.pointType,
};

_$HighlightItemImpl _$$HighlightItemImplFromJson(Map<String, dynamic> json) =>
    _$HighlightItemImpl(
      text: json['text'] as String,
      orderIndex: (json['orderIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$HighlightItemImplToJson(_$HighlightItemImpl instance) =>
    <String, dynamic>{'text': instance.text, 'orderIndex': instance.orderIndex};

_$InclusionItemImpl _$$InclusionItemImplFromJson(Map<String, dynamic> json) =>
    _$InclusionItemImpl(
      text: json['text'] as String,
      isIncluded: json['isIncluded'] as bool,
      orderIndex: (json['orderIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$InclusionItemImplToJson(_$InclusionItemImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'isIncluded': instance.isIncluded,
      'orderIndex': instance.orderIndex,
    };

_$ImportantInfoItemImpl _$$ImportantInfoItemImplFromJson(
  Map<String, dynamic> json,
) => _$ImportantInfoItemImpl(
  text: json['text'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
);

Map<String, dynamic> _$$ImportantInfoItemImplToJson(
  _$ImportantInfoItemImpl instance,
) => <String, dynamic>{
  'text': instance.text,
  'orderIndex': instance.orderIndex,
};
