// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_transport_booking_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateTransportBookingRequest _$CreateTransportBookingRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateTransportBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTransportBookingRequest {
  String get transportPricingId => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateToString)
  DateTime get date => throw _privateConstructorUsedError;
  String get pickupTime => throw _privateConstructorUsedError;
  String get pickupAddress => throw _privateConstructorUsedError;
  double get pickupLatitude => throw _privateConstructorUsedError;
  double get pickupLongitude => throw _privateConstructorUsedError;
  String get dropoffAddress => throw _privateConstructorUsedError;
  double get dropoffLatitude => throw _privateConstructorUsedError;
  double get dropoffLongitude => throw _privateConstructorUsedError;
  String get buyerFirstName => throw _privateConstructorUsedError;
  String get buyerLastName => throw _privateConstructorUsedError;
  String get buyerEmail => throw _privateConstructorUsedError;
  String get buyerPhone => throw _privateConstructorUsedError;

  /// Serializes this CreateTransportBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTransportBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTransportBookingRequestCopyWith<CreateTransportBookingRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTransportBookingRequestCopyWith<$Res> {
  factory $CreateTransportBookingRequestCopyWith(
    CreateTransportBookingRequest value,
    $Res Function(CreateTransportBookingRequest) then,
  ) =
      _$CreateTransportBookingRequestCopyWithImpl<
        $Res,
        CreateTransportBookingRequest
      >;
  @useResult
  $Res call({
    String transportPricingId,
    @JsonKey(toJson: _dateToString) DateTime date,
    String pickupTime,
    String pickupAddress,
    double pickupLatitude,
    double pickupLongitude,
    String dropoffAddress,
    double dropoffLatitude,
    double dropoffLongitude,
    String buyerFirstName,
    String buyerLastName,
    String buyerEmail,
    String buyerPhone,
  });
}

/// @nodoc
class _$CreateTransportBookingRequestCopyWithImpl<
  $Res,
  $Val extends CreateTransportBookingRequest
>
    implements $CreateTransportBookingRequestCopyWith<$Res> {
  _$CreateTransportBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTransportBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportPricingId = null,
    Object? date = null,
    Object? pickupTime = null,
    Object? pickupAddress = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? dropoffAddress = null,
    Object? dropoffLatitude = null,
    Object? dropoffLongitude = null,
    Object? buyerFirstName = null,
    Object? buyerLastName = null,
    Object? buyerEmail = null,
    Object? buyerPhone = null,
  }) {
    return _then(
      _value.copyWith(
            transportPricingId: null == transportPricingId
                ? _value.transportPricingId
                : transportPricingId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            pickupTime: null == pickupTime
                ? _value.pickupTime
                : pickupTime // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupAddress: null == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLatitude: null == pickupLatitude
                ? _value.pickupLatitude
                : pickupLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            pickupLongitude: null == pickupLongitude
                ? _value.pickupLongitude
                : pickupLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            dropoffAddress: null == dropoffAddress
                ? _value.dropoffAddress
                : dropoffAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            dropoffLatitude: null == dropoffLatitude
                ? _value.dropoffLatitude
                : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            dropoffLongitude: null == dropoffLongitude
                ? _value.dropoffLongitude
                : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            buyerFirstName: null == buyerFirstName
                ? _value.buyerFirstName
                : buyerFirstName // ignore: cast_nullable_to_non_nullable
                      as String,
            buyerLastName: null == buyerLastName
                ? _value.buyerLastName
                : buyerLastName // ignore: cast_nullable_to_non_nullable
                      as String,
            buyerEmail: null == buyerEmail
                ? _value.buyerEmail
                : buyerEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            buyerPhone: null == buyerPhone
                ? _value.buyerPhone
                : buyerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateTransportBookingRequestImplCopyWith<$Res>
    implements $CreateTransportBookingRequestCopyWith<$Res> {
  factory _$$CreateTransportBookingRequestImplCopyWith(
    _$CreateTransportBookingRequestImpl value,
    $Res Function(_$CreateTransportBookingRequestImpl) then,
  ) = __$$CreateTransportBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transportPricingId,
    @JsonKey(toJson: _dateToString) DateTime date,
    String pickupTime,
    String pickupAddress,
    double pickupLatitude,
    double pickupLongitude,
    String dropoffAddress,
    double dropoffLatitude,
    double dropoffLongitude,
    String buyerFirstName,
    String buyerLastName,
    String buyerEmail,
    String buyerPhone,
  });
}

/// @nodoc
class __$$CreateTransportBookingRequestImplCopyWithImpl<$Res>
    extends
        _$CreateTransportBookingRequestCopyWithImpl<
          $Res,
          _$CreateTransportBookingRequestImpl
        >
    implements _$$CreateTransportBookingRequestImplCopyWith<$Res> {
  __$$CreateTransportBookingRequestImplCopyWithImpl(
    _$CreateTransportBookingRequestImpl _value,
    $Res Function(_$CreateTransportBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTransportBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportPricingId = null,
    Object? date = null,
    Object? pickupTime = null,
    Object? pickupAddress = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? dropoffAddress = null,
    Object? dropoffLatitude = null,
    Object? dropoffLongitude = null,
    Object? buyerFirstName = null,
    Object? buyerLastName = null,
    Object? buyerEmail = null,
    Object? buyerPhone = null,
  }) {
    return _then(
      _$CreateTransportBookingRequestImpl(
        transportPricingId: null == transportPricingId
            ? _value.transportPricingId
            : transportPricingId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        pickupTime: null == pickupTime
            ? _value.pickupTime
            : pickupTime // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupAddress: null == pickupAddress
            ? _value.pickupAddress
            : pickupAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLatitude: null == pickupLatitude
            ? _value.pickupLatitude
            : pickupLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        pickupLongitude: null == pickupLongitude
            ? _value.pickupLongitude
            : pickupLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        dropoffAddress: null == dropoffAddress
            ? _value.dropoffAddress
            : dropoffAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        dropoffLatitude: null == dropoffLatitude
            ? _value.dropoffLatitude
            : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        dropoffLongitude: null == dropoffLongitude
            ? _value.dropoffLongitude
            : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        buyerFirstName: null == buyerFirstName
            ? _value.buyerFirstName
            : buyerFirstName // ignore: cast_nullable_to_non_nullable
                  as String,
        buyerLastName: null == buyerLastName
            ? _value.buyerLastName
            : buyerLastName // ignore: cast_nullable_to_non_nullable
                  as String,
        buyerEmail: null == buyerEmail
            ? _value.buyerEmail
            : buyerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        buyerPhone: null == buyerPhone
            ? _value.buyerPhone
            : buyerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTransportBookingRequestImpl
    implements _CreateTransportBookingRequest {
  const _$CreateTransportBookingRequestImpl({
    required this.transportPricingId,
    @JsonKey(toJson: _dateToString) required this.date,
    required this.pickupTime,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.buyerFirstName,
    required this.buyerLastName,
    required this.buyerEmail,
    required this.buyerPhone,
  });

  factory _$CreateTransportBookingRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateTransportBookingRequestImplFromJson(json);

  @override
  final String transportPricingId;
  @override
  @JsonKey(toJson: _dateToString)
  final DateTime date;
  @override
  final String pickupTime;
  @override
  final String pickupAddress;
  @override
  final double pickupLatitude;
  @override
  final double pickupLongitude;
  @override
  final String dropoffAddress;
  @override
  final double dropoffLatitude;
  @override
  final double dropoffLongitude;
  @override
  final String buyerFirstName;
  @override
  final String buyerLastName;
  @override
  final String buyerEmail;
  @override
  final String buyerPhone;

  @override
  String toString() {
    return 'CreateTransportBookingRequest(transportPricingId: $transportPricingId, date: $date, pickupTime: $pickupTime, pickupAddress: $pickupAddress, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropoffAddress: $dropoffAddress, dropoffLatitude: $dropoffLatitude, dropoffLongitude: $dropoffLongitude, buyerFirstName: $buyerFirstName, buyerLastName: $buyerLastName, buyerEmail: $buyerEmail, buyerPhone: $buyerPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTransportBookingRequestImpl &&
            (identical(other.transportPricingId, transportPricingId) ||
                other.transportPricingId == transportPricingId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.pickupTime, pickupTime) ||
                other.pickupTime == pickupTime) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.pickupLatitude, pickupLatitude) ||
                other.pickupLatitude == pickupLatitude) &&
            (identical(other.pickupLongitude, pickupLongitude) ||
                other.pickupLongitude == pickupLongitude) &&
            (identical(other.dropoffAddress, dropoffAddress) ||
                other.dropoffAddress == dropoffAddress) &&
            (identical(other.dropoffLatitude, dropoffLatitude) ||
                other.dropoffLatitude == dropoffLatitude) &&
            (identical(other.dropoffLongitude, dropoffLongitude) ||
                other.dropoffLongitude == dropoffLongitude) &&
            (identical(other.buyerFirstName, buyerFirstName) ||
                other.buyerFirstName == buyerFirstName) &&
            (identical(other.buyerLastName, buyerLastName) ||
                other.buyerLastName == buyerLastName) &&
            (identical(other.buyerEmail, buyerEmail) ||
                other.buyerEmail == buyerEmail) &&
            (identical(other.buyerPhone, buyerPhone) ||
                other.buyerPhone == buyerPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    transportPricingId,
    date,
    pickupTime,
    pickupAddress,
    pickupLatitude,
    pickupLongitude,
    dropoffAddress,
    dropoffLatitude,
    dropoffLongitude,
    buyerFirstName,
    buyerLastName,
    buyerEmail,
    buyerPhone,
  );

  /// Create a copy of CreateTransportBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTransportBookingRequestImplCopyWith<
    _$CreateTransportBookingRequestImpl
  >
  get copyWith =>
      __$$CreateTransportBookingRequestImplCopyWithImpl<
        _$CreateTransportBookingRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTransportBookingRequestImplToJson(this);
  }
}

abstract class _CreateTransportBookingRequest
    implements CreateTransportBookingRequest {
  const factory _CreateTransportBookingRequest({
    required final String transportPricingId,
    @JsonKey(toJson: _dateToString) required final DateTime date,
    required final String pickupTime,
    required final String pickupAddress,
    required final double pickupLatitude,
    required final double pickupLongitude,
    required final String dropoffAddress,
    required final double dropoffLatitude,
    required final double dropoffLongitude,
    required final String buyerFirstName,
    required final String buyerLastName,
    required final String buyerEmail,
    required final String buyerPhone,
  }) = _$CreateTransportBookingRequestImpl;

  factory _CreateTransportBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTransportBookingRequestImpl.fromJson;

  @override
  String get transportPricingId;
  @override
  @JsonKey(toJson: _dateToString)
  DateTime get date;
  @override
  String get pickupTime;
  @override
  String get pickupAddress;
  @override
  double get pickupLatitude;
  @override
  double get pickupLongitude;
  @override
  String get dropoffAddress;
  @override
  double get dropoffLatitude;
  @override
  double get dropoffLongitude;
  @override
  String get buyerFirstName;
  @override
  String get buyerLastName;
  @override
  String get buyerEmail;
  @override
  String get buyerPhone;

  /// Create a copy of CreateTransportBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTransportBookingRequestImplCopyWith<
    _$CreateTransportBookingRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
