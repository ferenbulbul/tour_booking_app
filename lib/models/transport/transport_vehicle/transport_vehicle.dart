import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_vehicle.freezed.dart';
part 'transport_vehicle.g.dart';

@freezed
class TransportVehicle with _$TransportVehicle {
  const factory TransportVehicle({
    required String vehicleId,
    required String transportPricingId,
    String? vehicleImage,
    @Default([]) List<String> otherImages,
    String? licensePlate,
    required int seatCount,
    required String brandName,
    required String className,
    String? modelYear,
    required num baseFee,
    required num pricePerKm,
    @Default(0) num totalPrice,
    @Default(0) double distanceKm,
    @Default(0) int estimatedDurationMinutes,
    @Default('TRY') String currency,
    required String driverName,
    String? driverPhoto,
    String? experienceYears,
    required String agencyName,
    String? tierName,
    String? tierBadgeColor,
    @Default(0) double avgRating,
    @Default(0) int ratingCount,
  }) = _TransportVehicle;

  factory TransportVehicle.fromJson(Map<String, dynamic> json) =>
      _$TransportVehicleFromJson(json);
}
