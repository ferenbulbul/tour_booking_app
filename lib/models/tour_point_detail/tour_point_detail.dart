import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/tour_point_detail_city/city_dto.dart';
import 'package:tour_booking/models/tour_point_detail_district/district_dto.dart';

part 'tour_point_detail.freezed.dart';
part 'tour_point_detail.g.dart';

@freezed
class TourPointDetail with _$TourPointDetail {
  const factory TourPointDetail({
    required String id,
    required String title,
    required String description,
    required String mainImage,
    required List<String> otherImages,
    required String cityName,
    required String districtName,
    required String regionName,
    required String countryName,
    required String tourTypeName,
    required String tourDifficultyName,
    required List<CityDto> cities,
    required List<DistrictDto> districts,
  }) = _TourPointDetail;

  factory TourPointDetail.fromJson(Map<String, dynamic> json) =>
      _$TourPointDetailFromJson(json);
}
