// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_price_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportCalculatePriceRequest _$TransportCalculatePriceRequestFromJson(
  Map<String, dynamic> json,
) {
  return _TransportCalculatePriceRequest.fromJson(json);
}

/// @nodoc
mixin _$TransportCalculatePriceRequest {
  String get transportPricingId => throw _privateConstructorUsedError;
  double get pickupLatitude => throw _privateConstructorUsedError;
  double get pickupLongitude => throw _privateConstructorUsedError;
  double get dropoffLatitude => throw _privateConstructorUsedError;
  double get dropoffLongitude => throw _privateConstructorUsedError;
  double? get clientDistanceKm => throw _privateConstructorUsedError;
  int? get clientDurationMinutes => throw _privateConstructorUsedError;

  /// Serializes this TransportCalculatePriceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportCalculatePriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportCalculatePriceRequestCopyWith<TransportCalculatePriceRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportCalculatePriceRequestCopyWith<$Res> {
  factory $TransportCalculatePriceRequestCopyWith(
    TransportCalculatePriceRequest value,
    $Res Function(TransportCalculatePriceRequest) then,
  ) =
      _$TransportCalculatePriceRequestCopyWithImpl<
        $Res,
        TransportCalculatePriceRequest
      >;
  @useResult
  $Res call({
    String transportPricingId,
    double pickupLatitude,
    double pickupLongitude,
    double dropoffLatitude,
    double dropoffLongitude,
    double? clientDistanceKm,
    int? clientDurationMinutes,
  });
}

/// @nodoc
class _$TransportCalculatePriceRequestCopyWithImpl<
  $Res,
  $Val extends TransportCalculatePriceRequest
>
    implements $TransportCalculatePriceRequestCopyWith<$Res> {
  _$TransportCalculatePriceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportCalculatePriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportPricingId = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? dropoffLatitude = null,
    Object? dropoffLongitude = null,
    Object? clientDistanceKm = freezed,
    Object? clientDurationMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            transportPricingId: null == transportPricingId
                ? _value.transportPricingId
                : transportPricingId // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLatitude: null == pickupLatitude
                ? _value.pickupLatitude
                : pickupLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            pickupLongitude: null == pickupLongitude
                ? _value.pickupLongitude
                : pickupLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            dropoffLatitude: null == dropoffLatitude
                ? _value.dropoffLatitude
                : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            dropoffLongitude: null == dropoffLongitude
                ? _value.dropoffLongitude
                : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            clientDistanceKm: freezed == clientDistanceKm
                ? _value.clientDistanceKm
                : clientDistanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            clientDurationMinutes: freezed == clientDurationMinutes
                ? _value.clientDurationMinutes
                : clientDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportCalculatePriceRequestImplCopyWith<$Res>
    implements $TransportCalculatePriceRequestCopyWith<$Res> {
  factory _$$TransportCalculatePriceRequestImplCopyWith(
    _$TransportCalculatePriceRequestImpl value,
    $Res Function(_$TransportCalculatePriceRequestImpl) then,
  ) = __$$TransportCalculatePriceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transportPricingId,
    double pickupLatitude,
    double pickupLongitude,
    double dropoffLatitude,
    double dropoffLongitude,
    double? clientDistanceKm,
    int? clientDurationMinutes,
  });
}

/// @nodoc
class __$$TransportCalculatePriceRequestImplCopyWithImpl<$Res>
    extends
        _$TransportCalculatePriceRequestCopyWithImpl<
          $Res,
          _$TransportCalculatePriceRequestImpl
        >
    implements _$$TransportCalculatePriceRequestImplCopyWith<$Res> {
  __$$TransportCalculatePriceRequestImplCopyWithImpl(
    _$TransportCalculatePriceRequestImpl _value,
    $Res Function(_$TransportCalculatePriceRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportCalculatePriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportPricingId = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? dropoffLatitude = null,
    Object? dropoffLongitude = null,
    Object? clientDistanceKm = freezed,
    Object? clientDurationMinutes = freezed,
  }) {
    return _then(
      _$TransportCalculatePriceRequestImpl(
        transportPricingId: null == transportPricingId
            ? _value.transportPricingId
            : transportPricingId // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLatitude: null == pickupLatitude
            ? _value.pickupLatitude
            : pickupLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        pickupLongitude: null == pickupLongitude
            ? _value.pickupLongitude
            : pickupLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        dropoffLatitude: null == dropoffLatitude
            ? _value.dropoffLatitude
            : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        dropoffLongitude: null == dropoffLongitude
            ? _value.dropoffLongitude
            : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        clientDistanceKm: freezed == clientDistanceKm
            ? _value.clientDistanceKm
            : clientDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        clientDurationMinutes: freezed == clientDurationMinutes
            ? _value.clientDurationMinutes
            : clientDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportCalculatePriceRequestImpl
    implements _TransportCalculatePriceRequest {
  const _$TransportCalculatePriceRequestImpl({
    required this.transportPricingId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.clientDistanceKm,
    this.clientDurationMinutes,
  });

  factory _$TransportCalculatePriceRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TransportCalculatePriceRequestImplFromJson(json);

  @override
  final String transportPricingId;
  @override
  final double pickupLatitude;
  @override
  final double pickupLongitude;
  @override
  final double dropoffLatitude;
  @override
  final double dropoffLongitude;
  @override
  final double? clientDistanceKm;
  @override
  final int? clientDurationMinutes;

  @override
  String toString() {
    return 'TransportCalculatePriceRequest(transportPricingId: $transportPricingId, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropoffLatitude: $dropoffLatitude, dropoffLongitude: $dropoffLongitude, clientDistanceKm: $clientDistanceKm, clientDurationMinutes: $clientDurationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportCalculatePriceRequestImpl &&
            (identical(other.transportPricingId, transportPricingId) ||
                other.transportPricingId == transportPricingId) &&
            (identical(other.pickupLatitude, pickupLatitude) ||
                other.pickupLatitude == pickupLatitude) &&
            (identical(other.pickupLongitude, pickupLongitude) ||
                other.pickupLongitude == pickupLongitude) &&
            (identical(other.dropoffLatitude, dropoffLatitude) ||
                other.dropoffLatitude == dropoffLatitude) &&
            (identical(other.dropoffLongitude, dropoffLongitude) ||
                other.dropoffLongitude == dropoffLongitude) &&
            (identical(other.clientDistanceKm, clientDistanceKm) ||
                other.clientDistanceKm == clientDistanceKm) &&
            (identical(other.clientDurationMinutes, clientDurationMinutes) ||
                other.clientDurationMinutes == clientDurationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    transportPricingId,
    pickupLatitude,
    pickupLongitude,
    dropoffLatitude,
    dropoffLongitude,
    clientDistanceKm,
    clientDurationMinutes,
  );

  /// Create a copy of TransportCalculatePriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportCalculatePriceRequestImplCopyWith<
    _$TransportCalculatePriceRequestImpl
  >
  get copyWith =>
      __$$TransportCalculatePriceRequestImplCopyWithImpl<
        _$TransportCalculatePriceRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportCalculatePriceRequestImplToJson(this);
  }
}

abstract class _TransportCalculatePriceRequest
    implements TransportCalculatePriceRequest {
  const factory _TransportCalculatePriceRequest({
    required final String transportPricingId,
    required final double pickupLatitude,
    required final double pickupLongitude,
    required final double dropoffLatitude,
    required final double dropoffLongitude,
    final double? clientDistanceKm,
    final int? clientDurationMinutes,
  }) = _$TransportCalculatePriceRequestImpl;

  factory _TransportCalculatePriceRequest.fromJson(Map<String, dynamic> json) =
      _$TransportCalculatePriceRequestImpl.fromJson;

  @override
  String get transportPricingId;
  @override
  double get pickupLatitude;
  @override
  double get pickupLongitude;
  @override
  double get dropoffLatitude;
  @override
  double get dropoffLongitude;
  @override
  double? get clientDistanceKm;
  @override
  int? get clientDurationMinutes;

  /// Create a copy of TransportCalculatePriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportCalculatePriceRequestImplCopyWith<
    _$TransportCalculatePriceRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
