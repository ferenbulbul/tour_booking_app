import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_destination_dto.freezed.dart';
part 'popular_destination_dto.g.dart';

@freezed
class PopularDestinationDto with _$PopularDestinationDto {
  const factory PopularDestinationDto({
    required String id,
    String? cityId,
    String? cityName,
    String? districtId,
    String? districtName,
    required String imageUrl,
    required int displayOrder,
  }) = _PopularDestinationDto;

  factory PopularDestinationDto.fromJson(Map<String, dynamic> json) =>
      _$PopularDestinationDtoFromJson(json);
}
