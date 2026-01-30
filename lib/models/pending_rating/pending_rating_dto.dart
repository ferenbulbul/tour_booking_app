import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_rating_dto.freezed.dart';
part 'pending_rating_dto.g.dart';

@freezed
class PendingRatingDto with _$PendingRatingDto {
  const factory PendingRatingDto({
    required String ratingRequestId,
    required List<PendingRatingTargetDto> targets,
  }) = _PendingRatingDto;

  factory PendingRatingDto.fromJson(Map<String, dynamic> json) =>
      _$PendingRatingDtoFromJson(json);
}

@freezed
class PendingRatingTargetDto with _$PendingRatingTargetDto {
  const factory PendingRatingTargetDto({
    required int targetType,
    required String targetId,
    required String displayName,
  }) = _PendingRatingTargetDto;

  factory PendingRatingTargetDto.fromJson(Map<String, dynamic> json) =>
      _$PendingRatingTargetDtoFromJson(json);
}
