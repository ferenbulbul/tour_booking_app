import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_vehicle.freezed.dart';
part 'driver_vehicle.g.dart';

@freezed
class DriverVehicle with _$DriverVehicle {
  const factory DriverVehicle({
    required String id,
    @Default('') String brand,
    @Default('') String model,
    @Default('') String plate,
    @Default(0) int seatCount,
    @Default('') String vehicleType,
    String? imageUrl,
    @Default(0) int year,
  }) = _DriverVehicle;

  factory DriverVehicle.fromJson(Map<String, dynamic> json) =>
      _$DriverVehicleFromJson(json);
}
