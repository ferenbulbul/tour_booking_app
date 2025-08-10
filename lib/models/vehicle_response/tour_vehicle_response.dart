import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';

part 'tour_vehicle_response.freezed.dart';
part 'tour_vehicle_response.g.dart';

@freezed
class TourVehicleResponse with _$TourVehicleResponse {
  const factory TourVehicleResponse({List<Vehicle>? vehicles}) =
      _TourVehicleResponse;

  factory TourVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$TourVehicleResponseFromJson(json);
}
