import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/driver_past_booking/driver_past_booking.dart';

part 'driver_past_booking_wrapper.freezed.dart';
part 'driver_past_booking_wrapper.g.dart';

@freezed
class DriverPastBookingWrapper with _$DriverPastBookingWrapper {
  const factory DriverPastBookingWrapper({
    required List<DriverPastBooking> bookings,
  }) = _DriverPastBookingWrapper;

  factory DriverPastBookingWrapper.fromJson(Map<String, dynamic> json) =>
      _$DriverPastBookingWrapperFromJson(json);
}
