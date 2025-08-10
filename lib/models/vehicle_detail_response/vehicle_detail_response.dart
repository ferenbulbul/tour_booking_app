import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';

part 'vehicle_detail_response.freezed.dart';
part 'vehicle_detail_response.g.dart';

@freezed
class VehicleResponse with _$VehicleResponse {
  const factory VehicleResponse({
    @JsonKey(name: 'vehicleDtos') required VehicleDetail? vehicleDtos,
  }) = _VehicleResponse;

  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseFromJson(json);
}
