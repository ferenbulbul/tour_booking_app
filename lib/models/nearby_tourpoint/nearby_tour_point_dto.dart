import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_tour_point_dto.freezed.dart';
part 'nearby_tour_point_dto.g.dart';

@freezed
class NearbyTourPointDto with _$NearbyTourPointDto {
  const factory NearbyTourPointDto({
    required String id,
    required String cityName,
    required String tourTypeName,
    required String title,
    required String mainImage,
    required double distance,
  }) = _NearbyTourPointDto;

  factory NearbyTourPointDto.fromJson(Map<String, dynamic> json) =>
      _$NearbyTourPointDtoFromJson(json);
}
