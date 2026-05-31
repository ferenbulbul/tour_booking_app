import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/driver_vehicle/driver_vehicle.dart';

part 'driver_profile.freezed.dart';
part 'driver_profile.g.dart';

@freezed
class DriverProfile with _$DriverProfile {
  const factory DriverProfile({
    required String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default(0.0) double averageRating,
    @Default(0) int totalTrips,
    @Default(0) int totalRatings,
    DriverVehicle? vehicle,
  }) = _DriverProfile;

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);
}
