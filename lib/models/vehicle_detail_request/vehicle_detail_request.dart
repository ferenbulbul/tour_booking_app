import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_detail_request.freezed.dart';
part 'vehicle_detail_request.g.dart';

@freezed
class VehicleDetailRequest with _$VehicleDetailRequest {
  const factory VehicleDetailRequest({
    required String vehicleId,
    required String tourRouteId,
  }) = _VehicleDetailRequest;

  factory VehicleDetailRequest.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailRequestFromJson(json);
}
