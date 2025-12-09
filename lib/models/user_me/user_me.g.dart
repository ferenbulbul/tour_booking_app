// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserMeImpl _$$UserMeImplFromJson(Map<String, dynamic> json) => _$UserMeImpl(
  userId: json['userId'] as String,
  emailConfirmed: json['emailConfirmed'] as bool,
  firstName: json['firstName'] as String,
);

Map<String, dynamic> _$$UserMeImplToJson(_$UserMeImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'emailConfirmed': instance.emailConfirmed,
      'firstName': instance.firstName,
    };
