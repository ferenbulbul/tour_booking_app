import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

@freezed
class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String tourPointName,
    required String tourPointCity,
    required String tourPointDistrict,
    required String departureTime,
    required String driverName,
    required int tourPointPrice,
    required String guideName,
    required int guidePrice,
    required int totalPrice,
    required String vehicleBrand,
    required int seatCount,
    required String departureLocationDescription,
    required String departureCity,
    required String departureDistrict,
    required String departureDate,
    required String status,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);
}
