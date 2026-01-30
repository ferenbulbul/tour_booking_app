// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_rating_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PendingRatingDtoImpl _$$PendingRatingDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PendingRatingDtoImpl(
  ratingRequestId: json['ratingRequestId'] as String,
  targets: (json['targets'] as List<dynamic>)
      .map((e) => PendingRatingTargetDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PendingRatingDtoImplToJson(
  _$PendingRatingDtoImpl instance,
) => <String, dynamic>{
  'ratingRequestId': instance.ratingRequestId,
  'targets': instance.targets.map((e) => e.toJson()).toList(),
};

_$PendingRatingTargetDtoImpl _$$PendingRatingTargetDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PendingRatingTargetDtoImpl(
  targetType: (json['targetType'] as num).toInt(),
  targetId: json['targetId'] as String,
  displayName: json['displayName'] as String,
);

Map<String, dynamic> _$$PendingRatingTargetDtoImplToJson(
  _$PendingRatingTargetDtoImpl instance,
) => <String, dynamic>{
  'targetType': instance.targetType,
  'targetId': instance.targetId,
  'displayName': instance.displayName,
};
