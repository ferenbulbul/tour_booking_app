import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/region/region_dto.dart';

part 'region_list_response.freezed.dart';
part 'region_list_response.g.dart';

@freezed
class MobileRegionListResponse with _$MobileRegionListResponse {
  const factory MobileRegionListResponse({
    @JsonKey(name: 'regionList') required List<MobileRegionDto> regions,
  }) = _MobileRegionListResponse;

  factory MobileRegionListResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileRegionListResponseFromJson(json);
}
