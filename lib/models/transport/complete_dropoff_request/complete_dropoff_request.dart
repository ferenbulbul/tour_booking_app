import 'package:freezed_annotation/freezed_annotation.dart';

part 'complete_dropoff_request.freezed.dart';
part 'complete_dropoff_request.g.dart';

@freezed
class TransportCompleteDropoffRequest with _$TransportCompleteDropoffRequest {
  const factory TransportCompleteDropoffRequest({
    required String bookingId,
  }) = _TransportCompleteDropoffRequest;

  factory TransportCompleteDropoffRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$TransportCompleteDropoffRequestFromJson(json);
}
