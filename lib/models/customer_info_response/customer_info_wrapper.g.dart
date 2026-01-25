// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoWrapperImpl _$$CustomerInfoWrapperImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerInfoWrapperImpl(
  customerInfo: (json['customerInfo'] as List<dynamic>)
      .map((e) => CustomerInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CustomerInfoWrapperImplToJson(
  _$CustomerInfoWrapperImpl instance,
) => <String, dynamic>{
  'customerInfo': instance.customerInfo.map((e) => e.toJson()).toList(),
};
