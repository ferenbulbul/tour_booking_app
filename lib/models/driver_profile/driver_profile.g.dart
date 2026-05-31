// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverProfileImpl _$$DriverProfileImplFromJson(Map<String, dynamic> json) =>
    _$DriverProfileImpl(
      fullName: json['fullName'] as String,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: (json['totalTrips'] as num?)?.toInt() ?? 0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      vehicle: json['vehicle'] == null
          ? null
          : DriverVehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DriverProfileImplToJson(_$DriverProfileImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'averageRating': instance.averageRating,
      'totalTrips': instance.totalTrips,
      'totalRatings': instance.totalRatings,
      'vehicle': instance.vehicle?.toJson(),
    };
