import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_detail.freezed.dart';
part 'vehicle_detail.g.dart';

@freezed
class VehicleDetail with _$VehicleDetail {
  const factory VehicleDetail({
    // JSON’da yoksa nullable yap
    String? vehicleId,
    int? price,

    // JSON’da var:
    required String vehicleBrand,
    required String vehicleClass,
    required String vehicleType,
    required int seatCount,
    required String image,
    String? legRoomSpace,
    String? seatType,
    int? modelYear, // JSON’da var, ekledim
  }) = _VehicleDetail;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailFromJson(json);
}
