import 'package:freezed_annotation/freezed_annotation.dart';
import '../tour/tour_type_dto.dart';

part 'tour_types_dto.freezed.dart';
part 'tour_types_dto.g.dart';

@freezed
class TourTypesDto with _$TourTypesDto {
  const factory TourTypesDto({
    @JsonKey(name: 'tourTypes') required List<TourTypeDto> tourTypes,
  }) = _TourTypesDto;

  factory TourTypesDto.fromJson(Map<String, dynamic> json) =>
      _$TourTypesDtoFromJson(json);
}
