// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleDetailImpl _$$VehicleDetailImplFromJson(Map<String, dynamic> json) =>
    _$VehicleDetailImpl(
      vehicleId: json['vehicleId'] as String?,
      price: (json['price'] as num?)?.toInt(),
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleClass: json['vehicleClass'] as String,
      vehicleType: json['vehicleType'] as String,
      legRoomSpace: json['legRoomSpace'] as String?,
      seatCount: (json['seatCount'] as num).toInt(),
      image: json['image'] as String,
      modelYear: json['modelYear'] as String?,
      otherImages: (json['otherImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vehicleFeatures: (json['vehicleFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nameSurname: json['nameSurname'] as String?,
      experienceYear: json['experienceYear'] as String?,
      photoUrl: json['photoUrl'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$VehicleDetailImplToJson(_$VehicleDetailImpl instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'price': instance.price,
      'vehicleBrand': instance.vehicleBrand,
      'vehicleClass': instance.vehicleClass,
      'vehicleType': instance.vehicleType,
      'legRoomSpace': instance.legRoomSpace,
      'seatCount': instance.seatCount,
      'image': instance.image,
      'modelYear': instance.modelYear,
      'otherImages': instance.otherImages,
      'vehicleFeatures': instance.vehicleFeatures,
      'nameSurname': instance.nameSurname,
      'experienceYear': instance.experienceYear,
      'photoUrl': instance.photoUrl,
      'languages': instance.languages,
    };
