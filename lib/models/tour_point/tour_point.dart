import 'package:freezed_annotation/freezed_annotation.dart';

part 'tour_point.freezed.dart';
part 'tour_point.g.dart';

@freezed
class TourPoint with _$TourPoint {
  const factory TourPoint({
    required String id,
    required String name,
    required String tourTypeId,
    required String tourTypeName,
    required String tourDifficultyId,
    required String tourDifficultyName,
    required String countryId,
    required String countryName,
    required String regionId,
    required String regionName,
    required String cityId,
    required String cityName,
    required String districtId,
    required String districtName,
    required String mainImage,
    required List<String> otherImages,
  }) = _TourPoint;

  factory TourPoint.fromJson(Map<String, dynamic> json) =>
      _$TourPointFromJson(json);
}
