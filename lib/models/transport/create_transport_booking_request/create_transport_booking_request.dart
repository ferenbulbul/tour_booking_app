import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'create_transport_booking_request.freezed.dart';
part 'create_transport_booking_request.g.dart';

@freezed
class CreateTransportBookingRequest with _$CreateTransportBookingRequest {
  const factory CreateTransportBookingRequest({
    required String transportPricingId,
    @JsonKey(toJson: _dateToString) required DateTime date,
    required String pickupTime,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String buyerFirstName,
    required String buyerLastName,
    required String buyerEmail,
    required String buyerPhone,
  }) = _CreateTransportBookingRequest;

  factory CreateTransportBookingRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateTransportBookingRequestFromJson(json);
}

String _dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
