import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

@freezed
class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String id,
    @Default('') String image,
    @Default('') String tourPointName,
    @Default('') String tourPointCity,
    @Default('') String tourPointDistrict,
    @Default('') String departureTime,
    @Default('') String driverName,
    @Default(0) num tourPointPrice,
    @Default('') String guideName,
    @Default(0) num guidePrice,
    @Default(0) num totalPrice,
    @Default('') String vehicleBrand,
    @Default(0) int seatCount,
    @Default('') String departureLocationDescription,
    @Default('') String departureCity,
    @Default('') String departureDistrict,
    @Default('') String departureDate,
    @Default('') String status,
    bool? canRate,
    String? ratingRequestId,
    String? ratingToken,
    @Default(0) int bookingType,
    String? pickupAddress,
    String? dropoffAddress,
    double? distanceKm,
    String? pickupTime,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);
}
