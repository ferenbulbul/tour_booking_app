// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseResponse<T>(
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  message: json['message'] as String?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  isSuccess: json['isSuccess'] as bool?,
  hasExceptionError: json['hasExceptionError'] as bool?,
  validationErrors: (json['validationErrors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'message': instance.message,
  'statusCode': instance.statusCode,
  'isSuccess': instance.isSuccess,
  'hasExceptionError': instance.hasExceptionError,
  'validationErrors': instance.validationErrors,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
