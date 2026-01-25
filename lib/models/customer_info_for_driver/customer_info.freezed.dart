// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) {
  return _CustomerInfo.fromJson(json);
}

/// @nodoc
mixin _$CustomerInfo {
  String get cutomerFullName => throw _privateConstructorUsedError;
  String get customerPhoneNumber => throw _privateConstructorUsedError;
  String get tourPointName => throw _privateConstructorUsedError;
  String get departureDescription => throw _privateConstructorUsedError;
  double get departureLatitude => throw _privateConstructorUsedError;
  double get departureLongitude => throw _privateConstructorUsedError;
  String get tourDate => throw _privateConstructorUsedError;
  @DriverBookingStatusConverter()
  DriverBookingStatus get status => throw _privateConstructorUsedError;

  /// Serializes this CustomerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInfoCopyWith<CustomerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInfoCopyWith<$Res> {
  factory $CustomerInfoCopyWith(
    CustomerInfo value,
    $Res Function(CustomerInfo) then,
  ) = _$CustomerInfoCopyWithImpl<$Res, CustomerInfo>;
  @useResult
  $Res call({
    String cutomerFullName,
    String customerPhoneNumber,
    String tourPointName,
    String departureDescription,
    double departureLatitude,
    double departureLongitude,
    String tourDate,
    @DriverBookingStatusConverter() DriverBookingStatus status,
  });
}

/// @nodoc
class _$CustomerInfoCopyWithImpl<$Res, $Val extends CustomerInfo>
    implements $CustomerInfoCopyWith<$Res> {
  _$CustomerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cutomerFullName = null,
    Object? customerPhoneNumber = null,
    Object? tourPointName = null,
    Object? departureDescription = null,
    Object? departureLatitude = null,
    Object? departureLongitude = null,
    Object? tourDate = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            cutomerFullName: null == cutomerFullName
                ? _value.cutomerFullName
                : cutomerFullName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhoneNumber: null == customerPhoneNumber
                ? _value.customerPhoneNumber
                : customerPhoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointName: null == tourPointName
                ? _value.tourPointName
                : tourPointName // ignore: cast_nullable_to_non_nullable
                      as String,
            departureDescription: null == departureDescription
                ? _value.departureDescription
                : departureDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            departureLatitude: null == departureLatitude
                ? _value.departureLatitude
                : departureLatitude // ignore: cast_nullable_to_non_nullable
                      as double,
            departureLongitude: null == departureLongitude
                ? _value.departureLongitude
                : departureLongitude // ignore: cast_nullable_to_non_nullable
                      as double,
            tourDate: null == tourDate
                ? _value.tourDate
                : tourDate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DriverBookingStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInfoImplCopyWith<$Res>
    implements $CustomerInfoCopyWith<$Res> {
  factory _$$CustomerInfoImplCopyWith(
    _$CustomerInfoImpl value,
    $Res Function(_$CustomerInfoImpl) then,
  ) = __$$CustomerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cutomerFullName,
    String customerPhoneNumber,
    String tourPointName,
    String departureDescription,
    double departureLatitude,
    double departureLongitude,
    String tourDate,
    @DriverBookingStatusConverter() DriverBookingStatus status,
  });
}

/// @nodoc
class __$$CustomerInfoImplCopyWithImpl<$Res>
    extends _$CustomerInfoCopyWithImpl<$Res, _$CustomerInfoImpl>
    implements _$$CustomerInfoImplCopyWith<$Res> {
  __$$CustomerInfoImplCopyWithImpl(
    _$CustomerInfoImpl _value,
    $Res Function(_$CustomerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cutomerFullName = null,
    Object? customerPhoneNumber = null,
    Object? tourPointName = null,
    Object? departureDescription = null,
    Object? departureLatitude = null,
    Object? departureLongitude = null,
    Object? tourDate = null,
    Object? status = null,
  }) {
    return _then(
      _$CustomerInfoImpl(
        cutomerFullName: null == cutomerFullName
            ? _value.cutomerFullName
            : cutomerFullName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhoneNumber: null == customerPhoneNumber
            ? _value.customerPhoneNumber
            : customerPhoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointName: null == tourPointName
            ? _value.tourPointName
            : tourPointName // ignore: cast_nullable_to_non_nullable
                  as String,
        departureDescription: null == departureDescription
            ? _value.departureDescription
            : departureDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        departureLatitude: null == departureLatitude
            ? _value.departureLatitude
            : departureLatitude // ignore: cast_nullable_to_non_nullable
                  as double,
        departureLongitude: null == departureLongitude
            ? _value.departureLongitude
            : departureLongitude // ignore: cast_nullable_to_non_nullable
                  as double,
        tourDate: null == tourDate
            ? _value.tourDate
            : tourDate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DriverBookingStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoImpl implements _CustomerInfo {
  const _$CustomerInfoImpl({
    required this.cutomerFullName,
    required this.customerPhoneNumber,
    required this.tourPointName,
    required this.departureDescription,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.tourDate,
    @DriverBookingStatusConverter() required this.status,
  });

  factory _$CustomerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoImplFromJson(json);

  @override
  final String cutomerFullName;
  @override
  final String customerPhoneNumber;
  @override
  final String tourPointName;
  @override
  final String departureDescription;
  @override
  final double departureLatitude;
  @override
  final double departureLongitude;
  @override
  final String tourDate;
  @override
  @DriverBookingStatusConverter()
  final DriverBookingStatus status;

  @override
  String toString() {
    return 'CustomerInfo(cutomerFullName: $cutomerFullName, customerPhoneNumber: $customerPhoneNumber, tourPointName: $tourPointName, departureDescription: $departureDescription, departureLatitude: $departureLatitude, departureLongitude: $departureLongitude, tourDate: $tourDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInfoImpl &&
            (identical(other.cutomerFullName, cutomerFullName) ||
                other.cutomerFullName == cutomerFullName) &&
            (identical(other.customerPhoneNumber, customerPhoneNumber) ||
                other.customerPhoneNumber == customerPhoneNumber) &&
            (identical(other.tourPointName, tourPointName) ||
                other.tourPointName == tourPointName) &&
            (identical(other.departureDescription, departureDescription) ||
                other.departureDescription == departureDescription) &&
            (identical(other.departureLatitude, departureLatitude) ||
                other.departureLatitude == departureLatitude) &&
            (identical(other.departureLongitude, departureLongitude) ||
                other.departureLongitude == departureLongitude) &&
            (identical(other.tourDate, tourDate) ||
                other.tourDate == tourDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cutomerFullName,
    customerPhoneNumber,
    tourPointName,
    departureDescription,
    departureLatitude,
    departureLongitude,
    tourDate,
    status,
  );

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInfoImplCopyWith<_$CustomerInfoImpl> get copyWith =>
      __$$CustomerInfoImplCopyWithImpl<_$CustomerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInfoImplToJson(this);
  }
}

abstract class _CustomerInfo implements CustomerInfo {
  const factory _CustomerInfo({
    required final String cutomerFullName,
    required final String customerPhoneNumber,
    required final String tourPointName,
    required final String departureDescription,
    required final double departureLatitude,
    required final double departureLongitude,
    required final String tourDate,
    @DriverBookingStatusConverter() required final DriverBookingStatus status,
  }) = _$CustomerInfoImpl;

  factory _CustomerInfo.fromJson(Map<String, dynamic> json) =
      _$CustomerInfoImpl.fromJson;

  @override
  String get cutomerFullName;
  @override
  String get customerPhoneNumber;
  @override
  String get tourPointName;
  @override
  String get departureDescription;
  @override
  double get departureLatitude;
  @override
  double get departureLongitude;
  @override
  String get tourDate;
  @override
  @DriverBookingStatusConverter()
  DriverBookingStatus get status;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoImplCopyWith<_$CustomerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
