// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) {
  return _DriverProfile.fromJson(json);
}

/// @nodoc
mixin _$DriverProfile {
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalTrips => throw _privateConstructorUsedError;
  int get totalRatings => throw _privateConstructorUsedError;
  DriverVehicle? get vehicle => throw _privateConstructorUsedError;

  /// Serializes this DriverProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverProfileCopyWith<DriverProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverProfileCopyWith<$Res> {
  factory $DriverProfileCopyWith(
    DriverProfile value,
    $Res Function(DriverProfile) then,
  ) = _$DriverProfileCopyWithImpl<$Res, DriverProfile>;
  @useResult
  $Res call({
    String fullName,
    String email,
    String phoneNumber,
    double averageRating,
    int totalTrips,
    int totalRatings,
    DriverVehicle? vehicle,
  });

  $DriverVehicleCopyWith<$Res>? get vehicle;
}

/// @nodoc
class _$DriverProfileCopyWithImpl<$Res, $Val extends DriverProfile>
    implements $DriverProfileCopyWith<$Res> {
  _$DriverProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? averageRating = null,
    Object? totalTrips = null,
    Object? totalRatings = null,
    Object? vehicle = freezed,
  }) {
    return _then(
      _value.copyWith(
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalTrips: null == totalTrips
                ? _value.totalTrips
                : totalTrips // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRatings: null == totalRatings
                ? _value.totalRatings
                : totalRatings // ignore: cast_nullable_to_non_nullable
                      as int,
            vehicle: freezed == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                      as DriverVehicle?,
          )
          as $Val,
    );
  }

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DriverVehicleCopyWith<$Res>? get vehicle {
    if (_value.vehicle == null) {
      return null;
    }

    return $DriverVehicleCopyWith<$Res>(_value.vehicle!, (value) {
      return _then(_value.copyWith(vehicle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DriverProfileImplCopyWith<$Res>
    implements $DriverProfileCopyWith<$Res> {
  factory _$$DriverProfileImplCopyWith(
    _$DriverProfileImpl value,
    $Res Function(_$DriverProfileImpl) then,
  ) = __$$DriverProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fullName,
    String email,
    String phoneNumber,
    double averageRating,
    int totalTrips,
    int totalRatings,
    DriverVehicle? vehicle,
  });

  @override
  $DriverVehicleCopyWith<$Res>? get vehicle;
}

/// @nodoc
class __$$DriverProfileImplCopyWithImpl<$Res>
    extends _$DriverProfileCopyWithImpl<$Res, _$DriverProfileImpl>
    implements _$$DriverProfileImplCopyWith<$Res> {
  __$$DriverProfileImplCopyWithImpl(
    _$DriverProfileImpl _value,
    $Res Function(_$DriverProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? averageRating = null,
    Object? totalTrips = null,
    Object? totalRatings = null,
    Object? vehicle = freezed,
  }) {
    return _then(
      _$DriverProfileImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalTrips: null == totalTrips
            ? _value.totalTrips
            : totalTrips // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRatings: null == totalRatings
            ? _value.totalRatings
            : totalRatings // ignore: cast_nullable_to_non_nullable
                  as int,
        vehicle: freezed == vehicle
            ? _value.vehicle
            : vehicle // ignore: cast_nullable_to_non_nullable
                  as DriverVehicle?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverProfileImpl implements _DriverProfile {
  const _$DriverProfileImpl({
    required this.fullName,
    this.email = '',
    this.phoneNumber = '',
    this.averageRating = 0.0,
    this.totalTrips = 0,
    this.totalRatings = 0,
    this.vehicle,
  });

  factory _$DriverProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverProfileImplFromJson(json);

  @override
  final String fullName;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int totalTrips;
  @override
  @JsonKey()
  final int totalRatings;
  @override
  final DriverVehicle? vehicle;

  @override
  String toString() {
    return 'DriverProfile(fullName: $fullName, email: $email, phoneNumber: $phoneNumber, averageRating: $averageRating, totalTrips: $totalTrips, totalRatings: $totalRatings, vehicle: $vehicle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverProfileImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalTrips, totalTrips) ||
                other.totalTrips == totalTrips) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    email,
    phoneNumber,
    averageRating,
    totalTrips,
    totalRatings,
    vehicle,
  );

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverProfileImplCopyWith<_$DriverProfileImpl> get copyWith =>
      __$$DriverProfileImplCopyWithImpl<_$DriverProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverProfileImplToJson(this);
  }
}

abstract class _DriverProfile implements DriverProfile {
  const factory _DriverProfile({
    required final String fullName,
    final String email,
    final String phoneNumber,
    final double averageRating,
    final int totalTrips,
    final int totalRatings,
    final DriverVehicle? vehicle,
  }) = _$DriverProfileImpl;

  factory _DriverProfile.fromJson(Map<String, dynamic> json) =
      _$DriverProfileImpl.fromJson;

  @override
  String get fullName;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  double get averageRating;
  @override
  int get totalTrips;
  @override
  int get totalRatings;
  @override
  DriverVehicle? get vehicle;

  /// Create a copy of DriverProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverProfileImplCopyWith<_$DriverProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
