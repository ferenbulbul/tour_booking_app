import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_past_booking.freezed.dart';
part 'driver_past_booking.g.dart';

@freezed
class DriverPastBooking with _$DriverPastBooking {
  const factory DriverPastBooking({
    required String id,
    @Default('') String customerName,
    @Default('') String tourPointName,
    @Default('') String departureDate,
    @Default('') String departureTime,
    @Default(0) num totalPrice,
    @Default('') String status,
    @Default(0) int bookingType,
    String? pickupAddress,
    String? dropoffAddress,
    double? rating,
    String? ratingComment,
  }) = _DriverPastBooking;

  factory DriverPastBooking.fromJson(Map<String, dynamic> json) =>
      _$DriverPastBookingFromJson(json);
}
