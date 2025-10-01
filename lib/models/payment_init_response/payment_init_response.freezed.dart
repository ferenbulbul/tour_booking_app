// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_init_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentInitResponse _$PaymentInitResponseFromJson(Map<String, dynamic> json) {
  return _PaymentInitResponse.fromJson(json);
}

/// @nodoc
mixin _$PaymentInitResponse {
  String get conversationId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get paymentPageUrl => throw _privateConstructorUsedError;
  int? get tokenExpireTime => throw _privateConstructorUsedError;

  /// Serializes this PaymentInitResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentInitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentInitResponseCopyWith<PaymentInitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInitResponseCopyWith<$Res> {
  factory $PaymentInitResponseCopyWith(
    PaymentInitResponse value,
    $Res Function(PaymentInitResponse) then,
  ) = _$PaymentInitResponseCopyWithImpl<$Res, PaymentInitResponse>;
  @useResult
  $Res call({
    String conversationId,
    String token,
    String paymentPageUrl,
    int? tokenExpireTime,
  });
}

/// @nodoc
class _$PaymentInitResponseCopyWithImpl<$Res, $Val extends PaymentInitResponse>
    implements $PaymentInitResponseCopyWith<$Res> {
  _$PaymentInitResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentInitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? token = null,
    Object? paymentPageUrl = null,
    Object? tokenExpireTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentPageUrl: null == paymentPageUrl
                ? _value.paymentPageUrl
                : paymentPageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            tokenExpireTime: freezed == tokenExpireTime
                ? _value.tokenExpireTime
                : tokenExpireTime // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentInitResponseImplCopyWith<$Res>
    implements $PaymentInitResponseCopyWith<$Res> {
  factory _$$PaymentInitResponseImplCopyWith(
    _$PaymentInitResponseImpl value,
    $Res Function(_$PaymentInitResponseImpl) then,
  ) = __$$PaymentInitResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String conversationId,
    String token,
    String paymentPageUrl,
    int? tokenExpireTime,
  });
}

/// @nodoc
class __$$PaymentInitResponseImplCopyWithImpl<$Res>
    extends _$PaymentInitResponseCopyWithImpl<$Res, _$PaymentInitResponseImpl>
    implements _$$PaymentInitResponseImplCopyWith<$Res> {
  __$$PaymentInitResponseImplCopyWithImpl(
    _$PaymentInitResponseImpl _value,
    $Res Function(_$PaymentInitResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentInitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? token = null,
    Object? paymentPageUrl = null,
    Object? tokenExpireTime = freezed,
  }) {
    return _then(
      _$PaymentInitResponseImpl(
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentPageUrl: null == paymentPageUrl
            ? _value.paymentPageUrl
            : paymentPageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        tokenExpireTime: freezed == tokenExpireTime
            ? _value.tokenExpireTime
            : tokenExpireTime // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentInitResponseImpl implements _PaymentInitResponse {
  const _$PaymentInitResponseImpl({
    required this.conversationId,
    required this.token,
    required this.paymentPageUrl,
    this.tokenExpireTime,
  });

  factory _$PaymentInitResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentInitResponseImplFromJson(json);

  @override
  final String conversationId;
  @override
  final String token;
  @override
  final String paymentPageUrl;
  @override
  final int? tokenExpireTime;

  @override
  String toString() {
    return 'PaymentInitResponse(conversationId: $conversationId, token: $token, paymentPageUrl: $paymentPageUrl, tokenExpireTime: $tokenExpireTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInitResponseImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.paymentPageUrl, paymentPageUrl) ||
                other.paymentPageUrl == paymentPageUrl) &&
            (identical(other.tokenExpireTime, tokenExpireTime) ||
                other.tokenExpireTime == tokenExpireTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    conversationId,
    token,
    paymentPageUrl,
    tokenExpireTime,
  );

  /// Create a copy of PaymentInitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInitResponseImplCopyWith<_$PaymentInitResponseImpl> get copyWith =>
      __$$PaymentInitResponseImplCopyWithImpl<_$PaymentInitResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInitResponseImplToJson(this);
  }
}

abstract class _PaymentInitResponse implements PaymentInitResponse {
  const factory _PaymentInitResponse({
    required final String conversationId,
    required final String token,
    required final String paymentPageUrl,
    final int? tokenExpireTime,
  }) = _$PaymentInitResponseImpl;

  factory _PaymentInitResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentInitResponseImpl.fromJson;

  @override
  String get conversationId;
  @override
  String get token;
  @override
  String get paymentPageUrl;
  @override
  int? get tokenExpireTime;

  /// Create a copy of PaymentInitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentInitResponseImplCopyWith<_$PaymentInitResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
