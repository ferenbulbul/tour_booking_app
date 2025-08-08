import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';

part 'mobile_tour_points_response.freezed.dart';
part 'mobile_tour_points_response.g.dart';

@freezed
class MobileTourPointsResponse with _$MobileTourPointsResponse {
  const factory MobileTourPointsResponse({
    @JsonKey(name: 'tourPoints')
    required List<MobileTourPointsBySearchDto> tourPoints,
  }) = _MobileTourPointsResponse;

  factory MobileTourPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileTourPointsResponseFromJson(json);
}
