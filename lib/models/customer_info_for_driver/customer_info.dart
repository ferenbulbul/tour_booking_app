import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/models/customer_info_for_driver/route_point.dart';

part 'customer_info.freezed.dart';
part 'customer_info.g.dart';

@freezed
class CustomerInfo with _$CustomerInfo {
  const factory CustomerInfo({
    @Default('') String cutomerFullName,
    @Default('') String customerPhoneNumber,
    @Default('') String tourPointName,
    @Default('') String departureDescription,
    @Default(0) double departureLatitude,
    @Default(0) double departureLongitude,
    @Default('') String tourDate,
    @DriverBookingStatusConverter() @Default(DriverBookingStatus.upcoming) DriverBookingStatus status,
    @Default(0) int bookingType,
    String? bookingId,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropoffAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? routePolyline,
    String? guideName,
    String? guidePhoneNumber,
    @Default(false) bool hasGuide,
    String? departureTime,
    @Default(<RoutePoint>[]) List<RoutePoint> routePoints,
    String? vehicleName,
    String? vehiclePlate,
    int? vehicleSeatCount,
  }) = _CustomerInfo;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}
