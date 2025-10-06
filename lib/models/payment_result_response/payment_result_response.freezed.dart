// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentResultResponse _$PaymentResultResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PaymentResultResponse.fromJson(json);
}

/// @nodoc
mixin _$PaymentResultResponse {
  String get paymentStatus => throw _privateConstructorUsedError;
  String get bookingStatus =>
      throw _privateConstructorUsedError; // SUCCESS / FAILURE
  String? get conversationId => throw _privateConstructorUsedError;

  /// Serializes this PaymentResultResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentResultResponseCopyWith<PaymentResultResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentResultResponseCopyWith<$Res> {
  factory $PaymentResultResponseCopyWith(
    PaymentResultResponse value,
    $Res Function(PaymentResultResponse) then,
  ) = _$PaymentResultResponseCopyWithImpl<$Res, PaymentResultResponse>;
  @useResult
  $Res call({
    String paymentStatus,
    String bookingStatus,
    String? conversationId,
  });
}

/// @nodoc
class _$PaymentResultResponseCopyWithImpl<
  $Res,
  $Val extends PaymentResultResponse
>
    implements $PaymentResultResponseCopyWith<$Res> {
  _$PaymentResultResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentStatus = null,
    Object? bookingStatus = null,
    Object? conversationId = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingStatus: null == bookingStatus
                ? _value.bookingStatus
                : bookingStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentResultResponseImplCopyWith<$Res>
    implements $PaymentResultResponseCopyWith<$Res> {
  factory _$$PaymentResultResponseImplCopyWith(
    _$PaymentResultResponseImpl value,
    $Res Function(_$PaymentResultResponseImpl) then,
  ) = __$$PaymentResultResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String paymentStatus,
    String bookingStatus,
    String? conversationId,
  });
}

/// @nodoc
class __$$PaymentResultResponseImplCopyWithImpl<$Res>
    extends
        _$PaymentResultResponseCopyWithImpl<$Res, _$PaymentResultResponseImpl>
    implements _$$PaymentResultResponseImplCopyWith<$Res> {
  __$$PaymentResultResponseImplCopyWithImpl(
    _$PaymentResultResponseImpl _value,
    $Res Function(_$PaymentResultResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentStatus = null,
    Object? bookingStatus = null,
    Object? conversationId = freezed,
  }) {
    return _then(
      _$PaymentResultResponseImpl(
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingStatus: null == bookingStatus
            ? _value.bookingStatus
            : bookingStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: freezed == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentResultResponseImpl implements _PaymentResultResponse {
  const _$PaymentResultResponseImpl({
    required this.paymentStatus,
    required this.bookingStatus,
    this.conversationId,
  });

  factory _$PaymentResultResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentResultResponseImplFromJson(json);

  @override
  final String paymentStatus;
  @override
  final String bookingStatus;
  // SUCCESS / FAILURE
  @override
  final String? conversationId;

  @override
  String toString() {
    return 'PaymentResultResponse(paymentStatus: $paymentStatus, bookingStatus: $bookingStatus, conversationId: $conversationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentResultResponseImpl &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.bookingStatus, bookingStatus) ||
                other.bookingStatus == bookingStatus) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentStatus, bookingStatus, conversationId);

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentResultResponseImplCopyWith<_$PaymentResultResponseImpl>
  get copyWith =>
      __$$PaymentResultResponseImplCopyWithImpl<_$PaymentResultResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentResultResponseImplToJson(this);
  }
}

abstract class _PaymentResultResponse implements PaymentResultResponse {
  const factory _PaymentResultResponse({
    required final String paymentStatus,
    required final String bookingStatus,
    final String? conversationId,
  }) = _$PaymentResultResponseImpl;

  factory _PaymentResultResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentResultResponseImpl.fromJson;

  @override
  String get paymentStatus;
  @override
  String get bookingStatus; // SUCCESS / FAILURE
  @override
  String? get conversationId;

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentResultResponseImplCopyWith<_$PaymentResultResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
