import 'package:freezed_annotation/freezed_annotation.dart';

part 'tour_type_dto.freezed.dart';
part 'tour_type_dto.g.dart';

@freezed
class TourTypeDto with _$TourTypeDto {
  const factory TourTypeDto({
    required String id,
    @JsonKey(name: 'mainImageUrl') required String mainImageUrl,
    @JsonKey(name: 'thumbImageUrl') required String thumbImageUrl,
    required String title,
    required String description,
  }) = _TourTypeDto;

  factory TourTypeDto.fromJson(Map<String, dynamic> json) =>
      _$TourTypeDtoFromJson(json);
}
