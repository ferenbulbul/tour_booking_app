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
  int get bookingType => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String? get pickupAddress => throw _privateConstructorUsedError;
  double? get pickupLatitude => throw _privateConstructorUsedError;
  double? get pickupLongitude => throw _privateConstructorUsedError;
  String? get dropoffAddress => throw _privateConstructorUsedError;
  double? get dropoffLatitude => throw _privateConstructorUsedError;
  double? get dropoffLongitude => throw _privateConstructorUsedError;
  String? get routePolyline => throw _privateConstructorUsedError;
  String? get guideName => throw _privateConstructorUsedError;
  String? get guidePhoneNumber => throw _privateConstructorUsedError;
  bool get hasGuide => throw _privateConstructorUsedError;
  String? get departureTime => throw _privateConstructorUsedError;
  List<RoutePoint> get routePoints => throw _privateConstructorUsedError;
  String? get vehicleName => throw _privateConstructorUsedError;
  String? get vehiclePlate => throw _privateConstructorUsedError;
  int? get vehicleSeatCount => throw _privateConstructorUsedError;

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
    int bookingType,
    String? bookingId,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropoffAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? routePolyline,
    String? guideName,
    String? guidePhoneNumber,
    bool hasGuide,
    String? departureTime,
    List<RoutePoint> routePoints,
    String? vehicleName,
    String? vehiclePlate,
    int? vehicleSeatCount,
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
    Object? bookingType = null,
    Object? bookingId = freezed,
    Object? pickupAddress = freezed,
    Object? pickupLatitude = freezed,
    Object? pickupLongitude = freezed,
    Object? dropoffAddress = freezed,
    Object? dropoffLatitude = freezed,
    Object? dropoffLongitude = freezed,
    Object? routePolyline = freezed,
    Object? guideName = freezed,
    Object? guidePhoneNumber = freezed,
    Object? hasGuide = null,
    Object? departureTime = freezed,
    Object? routePoints = null,
    Object? vehicleName = freezed,
    Object? vehiclePlate = freezed,
    Object? vehicleSeatCount = freezed,
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
            bookingType: null == bookingType
                ? _value.bookingType
                : bookingType // ignore: cast_nullable_to_non_nullable
                      as int,
            bookingId: freezed == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickupAddress: freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickupLatitude: freezed == pickupLatitude
                ? _value.pickupLatitude
                : pickupLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            pickupLongitude: freezed == pickupLongitude
                ? _value.pickupLongitude
                : pickupLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            dropoffAddress: freezed == dropoffAddress
                ? _value.dropoffAddress
                : dropoffAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            dropoffLatitude: freezed == dropoffLatitude
                ? _value.dropoffLatitude
                : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            dropoffLongitude: freezed == dropoffLongitude
                ? _value.dropoffLongitude
                : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            routePolyline: freezed == routePolyline
                ? _value.routePolyline
                : routePolyline // ignore: cast_nullable_to_non_nullable
                      as String?,
            guideName: freezed == guideName
                ? _value.guideName
                : guideName // ignore: cast_nullable_to_non_nullable
                      as String?,
            guidePhoneNumber: freezed == guidePhoneNumber
                ? _value.guidePhoneNumber
                : guidePhoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasGuide: null == hasGuide
                ? _value.hasGuide
                : hasGuide // ignore: cast_nullable_to_non_nullable
                      as bool,
            departureTime: freezed == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            routePoints: null == routePoints
                ? _value.routePoints
                : routePoints // ignore: cast_nullable_to_non_nullable
                      as List<RoutePoint>,
            vehicleName: freezed == vehicleName
                ? _value.vehicleName
                : vehicleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehiclePlate: freezed == vehiclePlate
                ? _value.vehiclePlate
                : vehiclePlate // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleSeatCount: freezed == vehicleSeatCount
                ? _value.vehicleSeatCount
                : vehicleSeatCount // ignore: cast_nullable_to_non_nullable
                      as int?,
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
    int bookingType,
    String? bookingId,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? dropoffAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? routePolyline,
    String? guideName,
    String? guidePhoneNumber,
    bool hasGuide,
    String? departureTime,
    List<RoutePoint> routePoints,
    String? vehicleName,
    String? vehiclePlate,
    int? vehicleSeatCount,
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
    Object? bookingType = null,
    Object? bookingId = freezed,
    Object? pickupAddress = freezed,
    Object? pickupLatitude = freezed,
    Object? pickupLongitude = freezed,
    Object? dropoffAddress = freezed,
    Object? dropoffLatitude = freezed,
    Object? dropoffLongitude = freezed,
    Object? routePolyline = freezed,
    Object? guideName = freezed,
    Object? guidePhoneNumber = freezed,
    Object? hasGuide = null,
    Object? departureTime = freezed,
    Object? routePoints = null,
    Object? vehicleName = freezed,
    Object? vehiclePlate = freezed,
    Object? vehicleSeatCount = freezed,
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
        bookingType: null == bookingType
            ? _value.bookingType
            : bookingType // ignore: cast_nullable_to_non_nullable
                  as int,
        bookingId: freezed == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickupAddress: freezed == pickupAddress
            ? _value.pickupAddress
            : pickupAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickupLatitude: freezed == pickupLatitude
            ? _value.pickupLatitude
            : pickupLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        pickupLongitude: freezed == pickupLongitude
            ? _value.pickupLongitude
            : pickupLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        dropoffAddress: freezed == dropoffAddress
            ? _value.dropoffAddress
            : dropoffAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        dropoffLatitude: freezed == dropoffLatitude
            ? _value.dropoffLatitude
            : dropoffLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        dropoffLongitude: freezed == dropoffLongitude
            ? _value.dropoffLongitude
            : dropoffLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        routePolyline: freezed == routePolyline
            ? _value.routePolyline
            : routePolyline // ignore: cast_nullable_to_non_nullable
                  as String?,
        guideName: freezed == guideName
            ? _value.guideName
            : guideName // ignore: cast_nullable_to_non_nullable
                  as String?,
        guidePhoneNumber: freezed == guidePhoneNumber
            ? _value.guidePhoneNumber
            : guidePhoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasGuide: null == hasGuide
            ? _value.hasGuide
            : hasGuide // ignore: cast_nullable_to_non_nullable
                  as bool,
        departureTime: freezed == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        routePoints: null == routePoints
            ? _value._routePoints
            : routePoints // ignore: cast_nullable_to_non_nullable
                  as List<RoutePoint>,
        vehicleName: freezed == vehicleName
            ? _value.vehicleName
            : vehicleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehiclePlate: freezed == vehiclePlate
            ? _value.vehiclePlate
            : vehiclePlate // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleSeatCount: freezed == vehicleSeatCount
            ? _value.vehicleSeatCount
            : vehicleSeatCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoImpl implements _CustomerInfo {
  const _$CustomerInfoImpl({
    this.cutomerFullName = '',
    this.customerPhoneNumber = '',
    this.tourPointName = '',
    this.departureDescription = '',
    this.departureLatitude = 0,
    this.departureLongitude = 0,
    this.tourDate = '',
    @DriverBookingStatusConverter() this.status = DriverBookingStatus.upcoming,
    this.bookingType = 0,
    this.bookingId,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropoffAddress,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.routePolyline,
    this.guideName,
    this.guidePhoneNumber,
    this.hasGuide = false,
    this.departureTime,
    final List<RoutePoint> routePoints = const <RoutePoint>[],
    this.vehicleName,
    this.vehiclePlate,
    this.vehicleSeatCount,
  }) : _routePoints = routePoints;

  factory _$CustomerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoImplFromJson(json);

  @override
  @JsonKey()
  final String cutomerFullName;
  @override
  @JsonKey()
  final String customerPhoneNumber;
  @override
  @JsonKey()
  final String tourPointName;
  @override
  @JsonKey()
  final String departureDescription;
  @override
  @JsonKey()
  final double departureLatitude;
  @override
  @JsonKey()
  final double departureLongitude;
  @override
  @JsonKey()
  final String tourDate;
  @override
  @JsonKey()
  @DriverBookingStatusConverter()
  final DriverBookingStatus status;
  @override
  @JsonKey()
  final int bookingType;
  @override
  final String? bookingId;
  @override
  final String? pickupAddress;
  @override
  final double? pickupLatitude;
  @override
  final double? pickupLongitude;
  @override
  final String? dropoffAddress;
  @override
  final double? dropoffLatitude;
  @override
  final double? dropoffLongitude;
  @override
  final String? routePolyline;
  @override
  final String? guideName;
  @override
  final String? guidePhoneNumber;
  @override
  @JsonKey()
  final bool hasGuide;
  @override
  final String? departureTime;
  final List<RoutePoint> _routePoints;
  @override
  @JsonKey()
  List<RoutePoint> get routePoints {
    if (_routePoints is EqualUnmodifiableListView) return _routePoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routePoints);
  }

  @override
  final String? vehicleName;
  @override
  final String? vehiclePlate;
  @override
  final int? vehicleSeatCount;

  @override
  String toString() {
    return 'CustomerInfo(cutomerFullName: $cutomerFullName, customerPhoneNumber: $customerPhoneNumber, tourPointName: $tourPointName, departureDescription: $departureDescription, departureLatitude: $departureLatitude, departureLongitude: $departureLongitude, tourDate: $tourDate, status: $status, bookingType: $bookingType, bookingId: $bookingId, pickupAddress: $pickupAddress, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropoffAddress: $dropoffAddress, dropoffLatitude: $dropoffLatitude, dropoffLongitude: $dropoffLongitude, routePolyline: $routePolyline, guideName: $guideName, guidePhoneNumber: $guidePhoneNumber, hasGuide: $hasGuide, departureTime: $departureTime, routePoints: $routePoints, vehicleName: $vehicleName, vehiclePlate: $vehiclePlate, vehicleSeatCount: $vehicleSeatCount)';
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
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
            (identical(other.routePolyline, routePolyline) ||
                other.routePolyline == routePolyline) &&
            (identical(other.guideName, guideName) ||
                other.guideName == guideName) &&
            (identical(other.guidePhoneNumber, guidePhoneNumber) ||
                other.guidePhoneNumber == guidePhoneNumber) &&
            (identical(other.hasGuide, hasGuide) ||
                other.hasGuide == hasGuide) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            const DeepCollectionEquality().equals(
              other._routePoints,
              _routePoints,
            ) &&
            (identical(other.vehicleName, vehicleName) ||
                other.vehicleName == vehicleName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.vehicleSeatCount, vehicleSeatCount) ||
                other.vehicleSeatCount == vehicleSeatCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    cutomerFullName,
    customerPhoneNumber,
    tourPointName,
    departureDescription,
    departureLatitude,
    departureLongitude,
    tourDate,
    status,
    bookingType,
    bookingId,
    pickupAddress,
    pickupLatitude,
    pickupLongitude,
    dropoffAddress,
    dropoffLatitude,
    dropoffLongitude,
    routePolyline,
    guideName,
    guidePhoneNumber,
    hasGuide,
    departureTime,
    const DeepCollectionEquality().hash(_routePoints),
    vehicleName,
    vehiclePlate,
    vehicleSeatCount,
  ]);

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
    final String cutomerFullName,
    final String customerPhoneNumber,
    final String tourPointName,
    final String departureDescription,
    final double departureLatitude,
    final double departureLongitude,
    final String tourDate,
    @DriverBookingStatusConverter() final DriverBookingStatus status,
    final int bookingType,
    final String? bookingId,
    final String? pickupAddress,
    final double? pickupLatitude,
    final double? pickupLongitude,
    final String? dropoffAddress,
    final double? dropoffLatitude,
    final double? dropoffLongitude,
    final String? routePolyline,
    final String? guideName,
    final String? guidePhoneNumber,
    final bool hasGuide,
    final String? departureTime,
    final List<RoutePoint> routePoints,
    final String? vehicleName,
    final String? vehiclePlate,
    final int? vehicleSeatCount,
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
  @override
  int get bookingType;
  @override
  String? get bookingId;
  @override
  String? get pickupAddress;
  @override
  double? get pickupLatitude;
  @override
  double? get pickupLongitude;
  @override
  String? get dropoffAddress;
  @override
  double? get dropoffLatitude;
  @override
  double? get dropoffLongitude;
  @override
  String? get routePolyline;
  @override
  String? get guideName;
  @override
  String? get guidePhoneNumber;
  @override
  bool get hasGuide;
  @override
  String? get departureTime;
  @override
  List<RoutePoint> get routePoints;
  @override
  String? get vehicleName;
  @override
  String? get vehiclePlate;
  @override
  int? get vehicleSeatCount;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoImplCopyWith<_$CustomerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
