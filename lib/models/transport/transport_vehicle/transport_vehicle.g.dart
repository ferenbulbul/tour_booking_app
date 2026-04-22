// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportVehicleImpl _$$TransportVehicleImplFromJson(
  Map<String, dynamic> json,
) => _$TransportVehicleImpl(
  vehicleId: json['vehicleId'] as String,
  transportPricingId: json['transportPricingId'] as String,
  vehicleImage: json['vehicleImage'] as String?,
  otherImages:
      (json['otherImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  licensePlate: json['licensePlate'] as String?,
  seatCount: (json['seatCount'] as num).toInt(),
  brandName: json['brandName'] as String,
  className: json['className'] as String,
  modelYear: json['modelYear'] as String?,
  baseFee: json['baseFee'] as num,
  pricePerKm: json['pricePerKm'] as num,
  currency: json['currency'] as String? ?? 'TRY',
  driverName: json['driverName'] as String,
  driverPhoto: json['driverPhoto'] as String?,
  experienceYears: json['experienceYears'] as String?,
  agencyName: json['agencyName'] as String,
  avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TransportVehicleImplToJson(
  _$TransportVehicleImpl instance,
) => <String, dynamic>{
  'vehicleId': instance.vehicleId,
  'transportPricingId': instance.transportPricingId,
  'vehicleImage': instance.vehicleImage,
  'otherImages': instance.otherImages,
  'licensePlate': instance.licensePlate,
  'seatCount': instance.seatCount,
  'brandName': instance.brandName,
  'className': instance.className,
  'modelYear': instance.modelYear,
  'baseFee': instance.baseFee,
  'pricePerKm': instance.pricePerKm,
  'currency': instance.currency,
  'driverName': instance.driverName,
  'driverPhoto': instance.driverPhoto,
  'experienceYears': instance.experienceYears,
  'agencyName': instance.agencyName,
  'avgRating': instance.avgRating,
  'ratingCount': instance.ratingCount,
};
