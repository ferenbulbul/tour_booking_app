import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_token_request.freezed.dart';
part 'firebase_token_request.g.dart';

@freezed
class FirebaseTokenRequest with _$FirebaseTokenRequest {
  const factory FirebaseTokenRequest({
    required String token,
    String? fullName,
    String? deviceId,
    String? deviceModel,
  }) = _FirebaseTokenRequest;

  factory FirebaseTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseTokenRequestFromJson(json);
}
