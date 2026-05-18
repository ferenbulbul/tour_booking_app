import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response.freezed.dart';
part 'profile_response.g.dart';

@freezed
class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default(false) bool phoneNumberConfirmed,
    @Default(false) bool emailNotification,
    @Default(false) bool pushNotification,
    @Default(false) bool smsNotification,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
