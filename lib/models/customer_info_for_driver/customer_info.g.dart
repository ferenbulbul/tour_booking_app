// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoImpl _$$CustomerInfoImplFromJson(Map<String, dynamic> json) =>
    _$CustomerInfoImpl(
      cutomerFullName: json['cutomerFullName'] as String? ?? '',
      customerPhoneNumber: json['customerPhoneNumber'] as String? ?? '',
      tourPointName: json['tourPointName'] as String? ?? '',
      departureDescription: json['departureDescription'] as String? ?? '',
      departureLatitude: (json['departureLatitude'] as num?)?.toDouble() ?? 0,
      departureLongitude: (json['departureLongitude'] as num?)?.toDouble() ?? 0,
      tourDate: json['tourDate'] as String? ?? '',
      status: json['status'] == null
          ? DriverBookingStatus.upcoming
          : const DriverBookingStatusConverter().fromJson(
              (json['status'] as num).toInt(),
            ),
      bookingType: (json['bookingType'] as num?)?.toInt() ?? 0,
      bookingId: json['bookingId'] as String?,
      pickupAddress: json['pickupAddress'] as String?,
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble(),
      dropoffAddress: json['dropoffAddress'] as String?,
      dropoffLatitude: (json['dropoffLatitude'] as num?)?.toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num?)?.toDouble(),
      routePolyline: json['routePolyline'] as String?,
      guideName: json['guideName'] as String?,
      guidePhoneNumber: json['guidePhoneNumber'] as String?,
      hasGuide: json['hasGuide'] as bool? ?? false,
      departureTime: json['departureTime'] as String?,
      routePoints:
          (json['routePoints'] as List<dynamic>?)
              ?.map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RoutePoint>[],
      vehicleName: json['vehicleName'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      vehicleSeatCount: (json['vehicleSeatCount'] as num?)?.toInt(),
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
      'bookingType': instance.bookingType,
      'bookingId': instance.bookingId,
      'pickupAddress': instance.pickupAddress,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'dropoffAddress': instance.dropoffAddress,
      'dropoffLatitude': instance.dropoffLatitude,
      'dropoffLongitude': instance.dropoffLongitude,
      'routePolyline': instance.routePolyline,
      'guideName': instance.guideName,
      'guidePhoneNumber': instance.guidePhoneNumber,
      'hasGuide': instance.hasGuide,
      'departureTime': instance.departureTime,
      'routePoints': instance.routePoints.map((e) => e.toJson()).toList(),
      'vehicleName': instance.vehicleName,
      'vehiclePlate': instance.vehiclePlate,
      'vehicleSeatCount': instance.vehicleSeatCount,
    };
