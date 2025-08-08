import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/city/city_dto.dart';

part 'city_list_response.freezed.dart';
part 'city_list_response.g.dart';

@freezed
class MobileCityListResponse with _$MobileCityListResponse {
  const factory MobileCityListResponse({
    @JsonKey(name: 'cityList') required List<MobileCityDto> cities,
  }) = _MobileCityListResponse;

  factory MobileCityListResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileCityListResponseFromJson(json);
}
