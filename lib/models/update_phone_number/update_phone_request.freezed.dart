// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_phone_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdatePhoneRequestDto _$UpdatePhoneRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  return _UpdatePhoneRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdatePhoneRequestDto {
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this UpdatePhoneRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePhoneRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePhoneRequestDtoCopyWith<UpdatePhoneRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePhoneRequestDtoCopyWith<$Res> {
  factory $UpdatePhoneRequestDtoCopyWith(
    UpdatePhoneRequestDto value,
    $Res Function(UpdatePhoneRequestDto) then,
  ) = _$UpdatePhoneRequestDtoCopyWithImpl<$Res, UpdatePhoneRequestDto>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class _$UpdatePhoneRequestDtoCopyWithImpl<
  $Res,
  $Val extends UpdatePhoneRequestDto
>
    implements $UpdatePhoneRequestDtoCopyWith<$Res> {
  _$UpdatePhoneRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePhoneRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _value.copyWith(
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdatePhoneRequestDtoImplCopyWith<$Res>
    implements $UpdatePhoneRequestDtoCopyWith<$Res> {
  factory _$$UpdatePhoneRequestDtoImplCopyWith(
    _$UpdatePhoneRequestDtoImpl value,
    $Res Function(_$UpdatePhoneRequestDtoImpl) then,
  ) = __$$UpdatePhoneRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$UpdatePhoneRequestDtoImplCopyWithImpl<$Res>
    extends
        _$UpdatePhoneRequestDtoCopyWithImpl<$Res, _$UpdatePhoneRequestDtoImpl>
    implements _$$UpdatePhoneRequestDtoImplCopyWith<$Res> {
  __$$UpdatePhoneRequestDtoImplCopyWithImpl(
    _$UpdatePhoneRequestDtoImpl _value,
    $Res Function(_$UpdatePhoneRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdatePhoneRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _$UpdatePhoneRequestDtoImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePhoneRequestDtoImpl implements _UpdatePhoneRequestDto {
  const _$UpdatePhoneRequestDtoImpl({required this.phoneNumber});

  factory _$UpdatePhoneRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePhoneRequestDtoImplFromJson(json);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'UpdatePhoneRequestDto(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePhoneRequestDtoImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of UpdatePhoneRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePhoneRequestDtoImplCopyWith<_$UpdatePhoneRequestDtoImpl>
  get copyWith =>
      __$$UpdatePhoneRequestDtoImplCopyWithImpl<_$UpdatePhoneRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePhoneRequestDtoImplToJson(this);
  }
}

abstract class _UpdatePhoneRequestDto implements UpdatePhoneRequestDto {
  const factory _UpdatePhoneRequestDto({required final String phoneNumber}) =
      _$UpdatePhoneRequestDtoImpl;

  factory _UpdatePhoneRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdatePhoneRequestDtoImpl.fromJson;

  @override
  String get phoneNumber;

  /// Create a copy of UpdatePhoneRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePhoneRequestDtoImplCopyWith<_$UpdatePhoneRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
