import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_phone_request.freezed.dart';
part 'update_phone_request.g.dart';

@freezed
class UpdatePhoneRequestDto with _$UpdatePhoneRequestDto {
  const factory UpdatePhoneRequestDto({
    required String phoneNumber,
    required String countryCode,
  }) = _UpdatePhoneRequestDto;

  factory UpdatePhoneRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePhoneRequestDtoFromJson(json);
}
