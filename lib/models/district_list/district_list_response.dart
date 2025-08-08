import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/district/district_dto.dart';

part 'district_list_response.freezed.dart';
part 'district_list_response.g.dart';

@freezed
class MobileDistrictListResponse with _$MobileDistrictListResponse {
  const factory MobileDistrictListResponse({
    @JsonKey(name: 'districtList') required List<MobileDistrictDto> districts,
  }) = _MobileDistrictListResponse;

  factory MobileDistrictListResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileDistrictListResponseFromJson(json);
}
