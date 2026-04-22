// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_locations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportSuggestedLocationsResponseImpl
_$$TransportSuggestedLocationsResponseImplFromJson(Map<String, dynamic> json) =>
    _$TransportSuggestedLocationsResponseImpl(
      locations:
          (json['locations'] as List<dynamic>?)
              ?.map(
                (e) => TransportSuggestedLocation.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TransportSuggestedLocationsResponseImplToJson(
  _$TransportSuggestedLocationsResponseImpl instance,
) => <String, dynamic>{
  'locations': instance.locations.map((e) => e.toJson()).toList(),
};
