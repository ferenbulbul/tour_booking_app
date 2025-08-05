import 'package:freezed_annotation/freezed_annotation.dart';

part 'featured_tour_point_dto.freezed.dart';
part 'featured_tour_point_dto.g.dart';

@freezed
class FeaturedTourPointDto with _$FeaturedTourPointDto {
  const factory FeaturedTourPointDto({
    required String id,
    required String cityId,
    required String cityName,
    required String countryId,
    required String countryName,
    required String regionId,
    required String regionName,
    required String tourTypeId,
    required String tourTypeName,
    required String mainImage,
    required String title,
    required String description,
  }) = _FeaturedTourPointDto;

  factory FeaturedTourPointDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedTourPointDtoFromJson(json);
}
