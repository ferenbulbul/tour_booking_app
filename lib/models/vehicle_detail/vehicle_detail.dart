import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_detail.freezed.dart';
part 'vehicle_detail.g.dart';

@freezed
class VehicleDetail with _$VehicleDetail {
  const factory VehicleDetail({
    String? vehicleId,
    int? price,
    required String vehicleBrand,
    required String vehicleClass,
    required String vehicleType,
    String? legRoomSpace,
    required int seatCount,
    required String image,
    String? modelYear,
    List<String>? otherImages,
    List<String>? vehicleFeatures,
    String? nameSurname,
    String? experienceYear,
    String? photoUrl,
    List<String>? languages,
  }) = _VehicleDetail;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailFromJson(json);
}
