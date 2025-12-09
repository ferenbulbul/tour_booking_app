import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_me.freezed.dart';
part 'user_me.g.dart';

@freezed
class UserMe with _$UserMe {
  const factory UserMe({
    required String userId,
    required bool emailConfirmed,
    required String firstName,
  }) = _UserMe;

  factory UserMe.fromJson(Map<String, dynamic> json) => _$UserMeFromJson(json);
}
