import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  BaseResponse({
    this.data,
    this.message,
    this.statusCode,
    this.isSuccess,
    this.hasExceptionError,
    this.validationErrors,
  });

  @JsonKey(name: 'data')
  final T? data;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;

  @JsonKey(name: 'hasExceptionError')
  final bool? hasExceptionError;

  @JsonKey(name: 'validationErrors')
  final List<String>? validationErrors;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
