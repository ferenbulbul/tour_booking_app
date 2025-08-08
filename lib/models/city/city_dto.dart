import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_dto.freezed.dart';
part 'city_dto.g.dart';

@freezed
class MobileCityDto with _$MobileCityDto {
  const factory MobileCityDto({required String id, required String name}) =
      _MobileCityDto;

  factory MobileCityDto.fromJson(Map<String, dynamic> json) =>
      _$MobileCityDtoFromJson(json);
}
