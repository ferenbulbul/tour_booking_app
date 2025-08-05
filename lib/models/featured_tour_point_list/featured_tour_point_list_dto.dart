import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';

part 'featured_tour_point_list_dto.freezed.dart';
part 'featured_tour_point_list_dto.g.dart';

@freezed
class FeaturedTourPointListDto with _$FeaturedTourPointListDto {
  const factory FeaturedTourPointListDto({
    @JsonKey(name: 'tourPoints') required List<FeaturedTourPointDto> tourPoints,
  }) = _FeaturedTourPointListDto;

  factory FeaturedTourPointListDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedTourPointListDtoFromJson(json);
}
