// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_destination_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PopularDestinationListDtoImpl _$$PopularDestinationListDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PopularDestinationListDtoImpl(
  popularDestinations:
      (json['popularDestinations'] as List<dynamic>?)
          ?.map(
            (e) => PopularDestinationDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PopularDestinationListDtoImplToJson(
  _$PopularDestinationListDtoImpl instance,
) => <String, dynamic>{
  'popularDestinations': instance.popularDestinations
      .map((e) => e.toJson())
      .toList(),
};
