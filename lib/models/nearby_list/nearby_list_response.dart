import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/nearby_tourpoint/nearby_tour_point_dto.dart';

part 'nearby_list_response.freezed.dart';
part 'nearby_list_response.g.dart';

@freezed
class NearbyListResponse with _$NearbyListResponse {
  const factory NearbyListResponse({
    required List<NearbyTourPointDto> nearByList,
  }) = _NearbyListResponse;

  factory NearbyListResponse.fromJson(Map<String, dynamic> json) =>
      _$NearbyListResponseFromJson(json);
}
