import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_valid_response.freezed.dart';
part 'is_valid_response.g.dart';

@freezed
class IsValidResponse with _$IsValidResponse {
  const factory IsValidResponse({
    required bool isValid,
    required String bookingId,
  }) = _IsValidResponse;

  factory IsValidResponse.fromJson(Map<String, dynamic> json) =>
      _$IsValidResponseFromJson(json);
}
