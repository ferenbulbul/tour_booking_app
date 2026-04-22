import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_booking_response.freezed.dart';
part 'transport_booking_response.g.dart';

@freezed
class TransportBookingResponse with _$TransportBookingResponse {
  const factory TransportBookingResponse({
    required String bookingId,
  }) = _TransportBookingResponse;

  factory TransportBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$TransportBookingResponseFromJson(json);
}
