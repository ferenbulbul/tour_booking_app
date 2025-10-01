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
  String get paymentStatus =>
      throw _privateConstructorUsedError; // SUCCESS / FAILURE
  String? get paymentId => throw _privateConstructorUsedError;
  String? get conversationId => throw _privateConstructorUsedError;
  String? get price => throw _privateConstructorUsedError;
  String? get paidPrice => throw _privateConstructorUsedError;
  String? get erorMessage => throw _privateConstructorUsedError;

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
    String? paymentId,
    String? conversationId,
    String? price,
    String? paidPrice,
    String? erorMessage,
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
    Object? paymentId = freezed,
    Object? conversationId = freezed,
    Object? price = freezed,
    Object? paidPrice = freezed,
    Object? erorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentId: freezed == paymentId
                ? _value.paymentId
                : paymentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            conversationId: freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidPrice: freezed == paidPrice
                ? _value.paidPrice
                : paidPrice // ignore: cast_nullable_to_non_nullable
                      as String?,
            erorMessage: freezed == erorMessage
                ? _value.erorMessage
                : erorMessage // ignore: cast_nullable_to_non_nullable
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
    String? paymentId,
    String? conversationId,
    String? price,
    String? paidPrice,
    String? erorMessage,
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
    Object? paymentId = freezed,
    Object? conversationId = freezed,
    Object? price = freezed,
    Object? paidPrice = freezed,
    Object? erorMessage = freezed,
  }) {
    return _then(
      _$PaymentResultResponseImpl(
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentId: freezed == paymentId
            ? _value.paymentId
            : paymentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        conversationId: freezed == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidPrice: freezed == paidPrice
            ? _value.paidPrice
            : paidPrice // ignore: cast_nullable_to_non_nullable
                  as String?,
        erorMessage: freezed == erorMessage
            ? _value.erorMessage
            : erorMessage // ignore: cast_nullable_to_non_nullable
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
    this.paymentId,
    this.conversationId,
    this.price,
    this.paidPrice,
    this.erorMessage,
  });

  factory _$PaymentResultResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentResultResponseImplFromJson(json);

  @override
  final String paymentStatus;
  // SUCCESS / FAILURE
  @override
  final String? paymentId;
  @override
  final String? conversationId;
  @override
  final String? price;
  @override
  final String? paidPrice;
  @override
  final String? erorMessage;

  @override
  String toString() {
    return 'PaymentResultResponse(paymentStatus: $paymentStatus, paymentId: $paymentId, conversationId: $conversationId, price: $price, paidPrice: $paidPrice, erorMessage: $erorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentResultResponseImpl &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.paidPrice, paidPrice) ||
                other.paidPrice == paidPrice) &&
            (identical(other.erorMessage, erorMessage) ||
                other.erorMessage == erorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentStatus,
    paymentId,
    conversationId,
    price,
    paidPrice,
    erorMessage,
  );

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
    final String? paymentId,
    final String? conversationId,
    final String? price,
    final String? paidPrice,
    final String? erorMessage,
  }) = _$PaymentResultResponseImpl;

  factory _PaymentResultResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentResultResponseImpl.fromJson;

  @override
  String get paymentStatus; // SUCCESS / FAILURE
  @override
  String? get paymentId;
  @override
  String? get conversationId;
  @override
  String? get price;
  @override
  String? get paidPrice;
  @override
  String? get erorMessage;

  /// Create a copy of PaymentResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentResultResponseImplCopyWith<_$PaymentResultResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
