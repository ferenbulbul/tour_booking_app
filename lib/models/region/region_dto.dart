import 'package:freezed_annotation/freezed_annotation.dart';

part 'region_dto.freezed.dart';
part 'region_dto.g.dart';

@freezed
class MobileRegionDto with _$MobileRegionDto {
  const factory MobileRegionDto({required String id, required String name}) =
      _MobileRegionDto;

  factory MobileRegionDto.fromJson(Map<String, dynamic> json) =>
      _$MobileRegionDtoFromJson(json);
}
