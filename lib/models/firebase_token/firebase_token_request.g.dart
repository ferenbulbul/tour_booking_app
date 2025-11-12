// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FirebaseTokenRequestImpl _$$FirebaseTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$FirebaseTokenRequestImpl(
  token: json['token'] as String,
  fullName: json['fullName'] as String?,
  deviceId: json['deviceId'] as String?,
  deviceModel: json['deviceModel'] as String?,
);

Map<String, dynamic> _$$FirebaseTokenRequestImplToJson(
  _$FirebaseTokenRequestImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'fullName': instance.fullName,
  'deviceId': instance.deviceId,
  'deviceModel': instance.deviceModel,
};
