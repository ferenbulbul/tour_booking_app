// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_price_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportPriceResult _$TransportPriceResultFromJson(Map<String, dynamic> json) {
  return _TransportPriceResult.fromJson(json);
}

/// @nodoc
mixin _$TransportPriceResult {
  double get distanceKm => throw _privateConstructorUsedError;
  int get estimatedDurationMinutes => throw _privateConstructorUsedError;
  num get baseFee => throw _privateConstructorUsedError;
  num get pricePerKm => throw _privateConstructorUsedError;
  num get totalPrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this TransportPriceResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportPriceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportPriceResultCopyWith<TransportPriceResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportPriceResultCopyWith<$Res> {
  factory $TransportPriceResultCopyWith(
    TransportPriceResult value,
    $Res Function(TransportPriceResult) then,
  ) = _$TransportPriceResultCopyWithImpl<$Res, TransportPriceResult>;
  @useResult
  $Res call({
    double distanceKm,
    int estimatedDurationMinutes,
    num baseFee,
    num pricePerKm,
    num totalPrice,
    String currency,
  });
}

/// @nodoc
class _$TransportPriceResultCopyWithImpl<
  $Res,
  $Val extends TransportPriceResult
>
    implements $TransportPriceResultCopyWith<$Res> {
  _$TransportPriceResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportPriceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceKm = null,
    Object? estimatedDurationMinutes = null,
    Object? baseFee = null,
    Object? pricePerKm = null,
    Object? totalPrice = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            distanceKm: null == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedDurationMinutes: null == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            baseFee: null == baseFee
                ? _value.baseFee
                : baseFee // ignore: cast_nullable_to_non_nullable
                      as num,
            pricePerKm: null == pricePerKm
                ? _value.pricePerKm
                : pricePerKm // ignore: cast_nullable_to_non_nullable
                      as num,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as num,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportPriceResultImplCopyWith<$Res>
    implements $TransportPriceResultCopyWith<$Res> {
  factory _$$TransportPriceResultImplCopyWith(
    _$TransportPriceResultImpl value,
    $Res Function(_$TransportPriceResultImpl) then,
  ) = __$$TransportPriceResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double distanceKm,
    int estimatedDurationMinutes,
    num baseFee,
    num pricePerKm,
    num totalPrice,
    String currency,
  });
}

/// @nodoc
class __$$TransportPriceResultImplCopyWithImpl<$Res>
    extends _$TransportPriceResultCopyWithImpl<$Res, _$TransportPriceResultImpl>
    implements _$$TransportPriceResultImplCopyWith<$Res> {
  __$$TransportPriceResultImplCopyWithImpl(
    _$TransportPriceResultImpl _value,
    $Res Function(_$TransportPriceResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportPriceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceKm = null,
    Object? estimatedDurationMinutes = null,
    Object? baseFee = null,
    Object? pricePerKm = null,
    Object? totalPrice = null,
    Object? currency = null,
  }) {
    return _then(
      _$TransportPriceResultImpl(
        distanceKm: null == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedDurationMinutes: null == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        baseFee: null == baseFee
            ? _value.baseFee
            : baseFee // ignore: cast_nullable_to_non_nullable
                  as num,
        pricePerKm: null == pricePerKm
            ? _value.pricePerKm
            : pricePerKm // ignore: cast_nullable_to_non_nullable
                  as num,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as num,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportPriceResultImpl implements _TransportPriceResult {
  const _$TransportPriceResultImpl({
    required this.distanceKm,
    required this.estimatedDurationMinutes,
    required this.baseFee,
    required this.pricePerKm,
    required this.totalPrice,
    this.currency = 'TRY',
  });

  factory _$TransportPriceResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportPriceResultImplFromJson(json);

  @override
  final double distanceKm;
  @override
  final int estimatedDurationMinutes;
  @override
  final num baseFee;
  @override
  final num pricePerKm;
  @override
  final num totalPrice;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'TransportPriceResult(distanceKm: $distanceKm, estimatedDurationMinutes: $estimatedDurationMinutes, baseFee: $baseFee, pricePerKm: $pricePerKm, totalPrice: $totalPrice, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportPriceResultImpl &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.baseFee, baseFee) || other.baseFee == baseFee) &&
            (identical(other.pricePerKm, pricePerKm) ||
                other.pricePerKm == pricePerKm) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    distanceKm,
    estimatedDurationMinutes,
    baseFee,
    pricePerKm,
    totalPrice,
    currency,
  );

  /// Create a copy of TransportPriceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportPriceResultImplCopyWith<_$TransportPriceResultImpl>
  get copyWith =>
      __$$TransportPriceResultImplCopyWithImpl<_$TransportPriceResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportPriceResultImplToJson(this);
  }
}

abstract class _TransportPriceResult implements TransportPriceResult {
  const factory _TransportPriceResult({
    required final double distanceKm,
    required final int estimatedDurationMinutes,
    required final num baseFee,
    required final num pricePerKm,
    required final num totalPrice,
    final String currency,
  }) = _$TransportPriceResultImpl;

  factory _TransportPriceResult.fromJson(Map<String, dynamic> json) =
      _$TransportPriceResultImpl.fromJson;

  @override
  double get distanceKm;
  @override
  int get estimatedDurationMinutes;
  @override
  num get baseFee;
  @override
  num get pricePerKm;
  @override
  num get totalPrice;
  @override
  String get currency;

  /// Create a copy of TransportPriceResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportPriceResultImplCopyWith<_$TransportPriceResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
