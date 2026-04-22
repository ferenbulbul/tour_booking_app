import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

part 'transport_vehicles_response.freezed.dart';
part 'transport_vehicles_response.g.dart';

@freezed
class TransportVehiclesResponse with _$TransportVehiclesResponse {
  const factory TransportVehiclesResponse({
    @Default([]) List<TransportVehicle> vehicles,
  }) = _TransportVehiclesResponse;

  factory TransportVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$TransportVehiclesResponseFromJson(json);
}
