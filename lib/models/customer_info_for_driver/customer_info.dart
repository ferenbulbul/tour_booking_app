import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';

part 'customer_info.freezed.dart';
part 'customer_info.g.dart';

@freezed
class CustomerInfo with _$CustomerInfo {
  const factory CustomerInfo({
    required String cutomerFullName,
    required String customerPhoneNumber,
    required String tourPointName,
    required String departureDescription,
    required double departureLatitude,
    required double departureLongitude,
    required String tourDate,
    @DriverBookingStatusConverter() required DriverBookingStatus status,
  }) = _CustomerInfo;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}
