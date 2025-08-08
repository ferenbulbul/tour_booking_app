import 'package:freezed_annotation/freezed_annotation.dart';

part 'district_dto.freezed.dart';
part 'district_dto.g.dart';

@freezed
class MobileDistrictDto with _$MobileDistrictDto {
  const factory MobileDistrictDto({required String id, required String name}) =
      _MobileDistrictDto;

  factory MobileDistrictDto.fromJson(Map<String, dynamic> json) =>
      _$MobileDistrictDtoFromJson(json);
}
