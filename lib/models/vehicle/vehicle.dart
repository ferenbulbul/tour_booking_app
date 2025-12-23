import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String tourRouteId,
    required String vehicleId,
    required num price,
    required String vehicleBrand,
    required String vehicleClass,
    required String vehicleType,
    required int seatCount,
    required String image,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}
