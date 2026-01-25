// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoImpl _$$CustomerInfoImplFromJson(Map<String, dynamic> json) =>
    _$CustomerInfoImpl(
      cutomerFullName: json['cutomerFullName'] as String,
      customerPhoneNumber: json['customerPhoneNumber'] as String,
      tourPointName: json['tourPointName'] as String,
      departureDescription: json['departureDescription'] as String,
      departureLatitude: (json['departureLatitude'] as num).toDouble(),
      departureLongitude: (json['departureLongitude'] as num).toDouble(),
      tourDate: json['tourDate'] as String,
      status: const DriverBookingStatusConverter().fromJson(
        (json['status'] as num).toInt(),
      ),
    );

Map<String, dynamic> _$$CustomerInfoImplToJson(_$CustomerInfoImpl instance) =>
    <String, dynamic>{
      'cutomerFullName': instance.cutomerFullName,
      'customerPhoneNumber': instance.customerPhoneNumber,
      'tourPointName': instance.tourPointName,
      'departureDescription': instance.departureDescription,
      'departureLatitude': instance.departureLatitude,
      'departureLongitude': instance.departureLongitude,
      'tourDate': instance.tourDate,
      'status': const DriverBookingStatusConverter().toJson(instance.status),
    };
