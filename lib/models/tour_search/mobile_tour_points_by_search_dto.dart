import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_tour_points_by_search_dto.freezed.dart';
part 'mobile_tour_points_by_search_dto.g.dart';

@freezed
class MobileTourPointsBySearchDto with _$MobileTourPointsBySearchDto {
  const factory MobileTourPointsBySearchDto({
    required String id,
    required String name,
    required String type,
  }) = _MobileTourPointsBySearchDto;

  factory MobileTourPointsBySearchDto.fromJson(Map<String, dynamic> json) =>
      _$MobileTourPointsBySearchDtoFromJson(json);
}
