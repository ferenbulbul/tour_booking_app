// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firebase_token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FirebaseTokenRequest _$FirebaseTokenRequestFromJson(Map<String, dynamic> json) {
  return _FirebaseTokenRequest.fromJson(json);
}

/// @nodoc
mixin _$FirebaseTokenRequest {
  String get token => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;

  /// Serializes this FirebaseTokenRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FirebaseTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FirebaseTokenRequestCopyWith<FirebaseTokenRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseTokenRequestCopyWith<$Res> {
  factory $FirebaseTokenRequestCopyWith(
    FirebaseTokenRequest value,
    $Res Function(FirebaseTokenRequest) then,
  ) = _$FirebaseTokenRequestCopyWithImpl<$Res, FirebaseTokenRequest>;
  @useResult
  $Res call({
    String token,
    String? fullName,
    String? deviceId,
    String? deviceModel,
  });
}

/// @nodoc
class _$FirebaseTokenRequestCopyWithImpl<
  $Res,
  $Val extends FirebaseTokenRequest
>
    implements $FirebaseTokenRequestCopyWith<$Res> {
  _$FirebaseTokenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FirebaseTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? fullName = freezed,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            deviceId: freezed == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            deviceModel: freezed == deviceModel
                ? _value.deviceModel
                : deviceModel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FirebaseTokenRequestImplCopyWith<$Res>
    implements $FirebaseTokenRequestCopyWith<$Res> {
  factory _$$FirebaseTokenRequestImplCopyWith(
    _$FirebaseTokenRequestImpl value,
    $Res Function(_$FirebaseTokenRequestImpl) then,
  ) = __$$FirebaseTokenRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String? fullName,
    String? deviceId,
    String? deviceModel,
  });
}

/// @nodoc
class __$$FirebaseTokenRequestImplCopyWithImpl<$Res>
    extends _$FirebaseTokenRequestCopyWithImpl<$Res, _$FirebaseTokenRequestImpl>
    implements _$$FirebaseTokenRequestImplCopyWith<$Res> {
  __$$FirebaseTokenRequestImplCopyWithImpl(
    _$FirebaseTokenRequestImpl _value,
    $Res Function(_$FirebaseTokenRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FirebaseTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? fullName = freezed,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
  }) {
    return _then(
      _$FirebaseTokenRequestImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        deviceId: freezed == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deviceModel: freezed == deviceModel
            ? _value.deviceModel
            : deviceModel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FirebaseTokenRequestImpl implements _FirebaseTokenRequest {
  const _$FirebaseTokenRequestImpl({
    required this.token,
    this.fullName,
    this.deviceId,
    this.deviceModel,
  });

  factory _$FirebaseTokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FirebaseTokenRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String? fullName;
  @override
  final String? deviceId;
  @override
  final String? deviceModel;

  @override
  String toString() {
    return 'FirebaseTokenRequest(token: $token, fullName: $fullName, deviceId: $deviceId, deviceModel: $deviceModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirebaseTokenRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, fullName, deviceId, deviceModel);

  /// Create a copy of FirebaseTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FirebaseTokenRequestImplCopyWith<_$FirebaseTokenRequestImpl>
  get copyWith =>
      __$$FirebaseTokenRequestImplCopyWithImpl<_$FirebaseTokenRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FirebaseTokenRequestImplToJson(this);
  }
}

abstract class _FirebaseTokenRequest implements FirebaseTokenRequest {
  const factory _FirebaseTokenRequest({
    required final String token,
    final String? fullName,
    final String? deviceId,
    final String? deviceModel,
  }) = _$FirebaseTokenRequestImpl;

  factory _FirebaseTokenRequest.fromJson(Map<String, dynamic> json) =
      _$FirebaseTokenRequestImpl.fromJson;

  @override
  String get token;
  @override
  String? get fullName;
  @override
  String? get deviceId;
  @override
  String? get deviceModel;

  /// Create a copy of FirebaseTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FirebaseTokenRequestImplCopyWith<_$FirebaseTokenRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
