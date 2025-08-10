import 'package:freezed_annotation/freezed_annotation.dart';

part 'district_dto.freezed.dart';
part 'district_dto.g.dart';

@freezed
class DistrictDto with _$DistrictDto {
  const factory DistrictDto({
    required String id,
    required String name,
    required String cityId,
  }) = _DistrictDto;

  factory DistrictDto.fromJson(Map<String, dynamic> json) =>
      _$DistrictDtoFromJson(json);
}
