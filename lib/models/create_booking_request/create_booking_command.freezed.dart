// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_booking_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateBookingCommand _$CreateBookingCommandFromJson(Map<String, dynamic> json) {
  return _CreateBookingCommand.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingCommand {
  String get tourPointId => throw _privateConstructorUsedError;
  String? get guideId => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;
  String get districtId => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get departureTime => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal get tourPrice => throw _privateConstructorUsedError;
  @DecimalConverter()
  Decimal? get guidePrice => throw _privateConstructorUsedError;
  double? get Latitude => throw _privateConstructorUsedError;
  double? get Longitude => throw _privateConstructorUsedError;
  String? get LocationDescription => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateToString)
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this CreateBookingCommand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBookingCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBookingCommandCopyWith<CreateBookingCommand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingCommandCopyWith<$Res> {
  factory $CreateBookingCommandCopyWith(
    CreateBookingCommand value,
    $Res Function(CreateBookingCommand) then,
  ) = _$CreateBookingCommandCopyWithImpl<$Res, CreateBookingCommand>;
  @useResult
  $Res call({
    String tourPointId,
    String? guideId,
    String cityId,
    String districtId,
    String vehicleId,
    String departureTime,
    @DecimalConverter() Decimal tourPrice,
    @DecimalConverter() Decimal? guidePrice,
    double? Latitude,
    double? Longitude,
    String? LocationDescription,
    @JsonKey(toJson: _dateToString) DateTime date,
  });
}

/// @nodoc
class _$CreateBookingCommandCopyWithImpl<
  $Res,
  $Val extends CreateBookingCommand
>
    implements $CreateBookingCommandCopyWith<$Res> {
  _$CreateBookingCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBookingCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tourPointId = null,
    Object? guideId = freezed,
    Object? cityId = null,
    Object? districtId = null,
    Object? vehicleId = null,
    Object? departureTime = null,
    Object? tourPrice = null,
    Object? guidePrice = freezed,
    Object? Latitude = freezed,
    Object? Longitude = freezed,
    Object? LocationDescription = freezed,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            tourPointId: null == tourPointId
                ? _value.tourPointId
                : tourPointId // ignore: cast_nullable_to_non_nullable
                      as String,
            guideId: freezed == guideId
                ? _value.guideId
                : guideId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            districtId: null == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleId: null == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPrice: null == tourPrice
                ? _value.tourPrice
                : tourPrice // ignore: cast_nullable_to_non_nullable
                      as Decimal,
            guidePrice: freezed == guidePrice
                ? _value.guidePrice
                : guidePrice // ignore: cast_nullable_to_non_nullable
                      as Decimal?,
            Latitude: freezed == Latitude
                ? _value.Latitude
                : Latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            Longitude: freezed == Longitude
                ? _value.Longitude
                : Longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            LocationDescription: freezed == LocationDescription
                ? _value.LocationDescription
                : LocationDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateBookingCommandImplCopyWith<$Res>
    implements $CreateBookingCommandCopyWith<$Res> {
  factory _$$CreateBookingCommandImplCopyWith(
    _$CreateBookingCommandImpl value,
    $Res Function(_$CreateBookingCommandImpl) then,
  ) = __$$CreateBookingCommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tourPointId,
    String? guideId,
    String cityId,
    String districtId,
    String vehicleId,
    String departureTime,
    @DecimalConverter() Decimal tourPrice,
    @DecimalConverter() Decimal? guidePrice,
    double? Latitude,
    double? Longitude,
    String? LocationDescription,
    @JsonKey(toJson: _dateToString) DateTime date,
  });
}

/// @nodoc
class __$$CreateBookingCommandImplCopyWithImpl<$Res>
    extends _$CreateBookingCommandCopyWithImpl<$Res, _$CreateBookingCommandImpl>
    implements _$$CreateBookingCommandImplCopyWith<$Res> {
  __$$CreateBookingCommandImplCopyWithImpl(
    _$CreateBookingCommandImpl _value,
    $Res Function(_$CreateBookingCommandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBookingCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tourPointId = null,
    Object? guideId = freezed,
    Object? cityId = null,
    Object? districtId = null,
    Object? vehicleId = null,
    Object? departureTime = null,
    Object? tourPrice = null,
    Object? guidePrice = freezed,
    Object? Latitude = freezed,
    Object? Longitude = freezed,
    Object? LocationDescription = freezed,
    Object? date = null,
  }) {
    return _then(
      _$CreateBookingCommandImpl(
        tourPointId: null == tourPointId
            ? _value.tourPointId
            : tourPointId // ignore: cast_nullable_to_non_nullable
                  as String,
        guideId: freezed == guideId
            ? _value.guideId
            : guideId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        districtId: null == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleId: null == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPrice: null == tourPrice
            ? _value.tourPrice
            : tourPrice // ignore: cast_nullable_to_non_nullable
                  as Decimal,
        guidePrice: freezed == guidePrice
            ? _value.guidePrice
            : guidePrice // ignore: cast_nullable_to_non_nullable
                  as Decimal?,
        Latitude: freezed == Latitude
            ? _value.Latitude
            : Latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        Longitude: freezed == Longitude
            ? _value.Longitude
            : Longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        LocationDescription: freezed == LocationDescription
            ? _value.LocationDescription
            : LocationDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingCommandImpl implements _CreateBookingCommand {
  const _$CreateBookingCommandImpl({
    required this.tourPointId,
    this.guideId,
    required this.cityId,
    required this.districtId,
    required this.vehicleId,
    required this.departureTime,
    @DecimalConverter() required this.tourPrice,
    @DecimalConverter() this.guidePrice,
    this.Latitude,
    this.Longitude,
    this.LocationDescription,
    @JsonKey(toJson: _dateToString) required this.date,
  });

  factory _$CreateBookingCommandImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingCommandImplFromJson(json);

  @override
  final String tourPointId;
  @override
  final String? guideId;
  @override
  final String cityId;
  @override
  final String districtId;
  @override
  final String vehicleId;
  @override
  final String departureTime;
  @override
  @DecimalConverter()
  final Decimal tourPrice;
  @override
  @DecimalConverter()
  final Decimal? guidePrice;
  @override
  final double? Latitude;
  @override
  final double? Longitude;
  @override
  final String? LocationDescription;
  @override
  @JsonKey(toJson: _dateToString)
  final DateTime date;

  @override
  String toString() {
    return 'CreateBookingCommand(tourPointId: $tourPointId, guideId: $guideId, cityId: $cityId, districtId: $districtId, vehicleId: $vehicleId, departureTime: $departureTime, tourPrice: $tourPrice, guidePrice: $guidePrice, Latitude: $Latitude, Longitude: $Longitude, LocationDescription: $LocationDescription, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingCommandImpl &&
            (identical(other.tourPointId, tourPointId) ||
                other.tourPointId == tourPointId) &&
            (identical(other.guideId, guideId) || other.guideId == guideId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.tourPrice, tourPrice) ||
                other.tourPrice == tourPrice) &&
            (identical(other.guidePrice, guidePrice) ||
                other.guidePrice == guidePrice) &&
            (identical(other.Latitude, Latitude) ||
                other.Latitude == Latitude) &&
            (identical(other.Longitude, Longitude) ||
                other.Longitude == Longitude) &&
            (identical(other.LocationDescription, LocationDescription) ||
                other.LocationDescription == LocationDescription) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tourPointId,
    guideId,
    cityId,
    districtId,
    vehicleId,
    departureTime,
    tourPrice,
    guidePrice,
    Latitude,
    Longitude,
    LocationDescription,
    date,
  );

  /// Create a copy of CreateBookingCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingCommandImplCopyWith<_$CreateBookingCommandImpl>
  get copyWith =>
      __$$CreateBookingCommandImplCopyWithImpl<_$CreateBookingCommandImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingCommandImplToJson(this);
  }
}

abstract class _CreateBookingCommand implements CreateBookingCommand {
  const factory _CreateBookingCommand({
    required final String tourPointId,
    final String? guideId,
    required final String cityId,
    required final String districtId,
    required final String vehicleId,
    required final String departureTime,
    @DecimalConverter() required final Decimal tourPrice,
    @DecimalConverter() final Decimal? guidePrice,
    final double? Latitude,
    final double? Longitude,
    final String? LocationDescription,
    @JsonKey(toJson: _dateToString) required final DateTime date,
  }) = _$CreateBookingCommandImpl;

  factory _CreateBookingCommand.fromJson(Map<String, dynamic> json) =
      _$CreateBookingCommandImpl.fromJson;

  @override
  String get tourPointId;
  @override
  String? get guideId;
  @override
  String get cityId;
  @override
  String get districtId;
  @override
  String get vehicleId;
  @override
  String get departureTime;
  @override
  @DecimalConverter()
  Decimal get tourPrice;
  @override
  @DecimalConverter()
  Decimal? get guidePrice;
  @override
  double? get Latitude;
  @override
  double? get Longitude;
  @override
  String? get LocationDescription;
  @override
  @JsonKey(toJson: _dateToString)
  DateTime get date;

  /// Create a copy of CreateBookingCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBookingCommandImplCopyWith<_$CreateBookingCommandImpl>
  get copyWith => throw _privateConstructorUsedError;
}
