// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverVehicle _$DriverVehicleFromJson(Map<String, dynamic> json) {
  return _DriverVehicle.fromJson(json);
}

/// @nodoc
mixin _$DriverVehicle {
  String get id => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get plate => throw _privateConstructorUsedError;
  int get seatCount => throw _privateConstructorUsedError;
  String get vehicleType => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;

  /// Serializes this DriverVehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverVehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverVehicleCopyWith<DriverVehicle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverVehicleCopyWith<$Res> {
  factory $DriverVehicleCopyWith(
    DriverVehicle value,
    $Res Function(DriverVehicle) then,
  ) = _$DriverVehicleCopyWithImpl<$Res, DriverVehicle>;
  @useResult
  $Res call({
    String id,
    String brand,
    String model,
    String plate,
    int seatCount,
    String vehicleType,
    String? imageUrl,
    int year,
  });
}

/// @nodoc
class _$DriverVehicleCopyWithImpl<$Res, $Val extends DriverVehicle>
    implements $DriverVehicleCopyWith<$Res> {
  _$DriverVehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverVehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? plate = null,
    Object? seatCount = null,
    Object? vehicleType = null,
    Object? imageUrl = freezed,
    Object? year = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            brand: null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            plate: null == plate
                ? _value.plate
                : plate // ignore: cast_nullable_to_non_nullable
                      as String,
            seatCount: null == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            vehicleType: null == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverVehicleImplCopyWith<$Res>
    implements $DriverVehicleCopyWith<$Res> {
  factory _$$DriverVehicleImplCopyWith(
    _$DriverVehicleImpl value,
    $Res Function(_$DriverVehicleImpl) then,
  ) = __$$DriverVehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String brand,
    String model,
    String plate,
    int seatCount,
    String vehicleType,
    String? imageUrl,
    int year,
  });
}

/// @nodoc
class __$$DriverVehicleImplCopyWithImpl<$Res>
    extends _$DriverVehicleCopyWithImpl<$Res, _$DriverVehicleImpl>
    implements _$$DriverVehicleImplCopyWith<$Res> {
  __$$DriverVehicleImplCopyWithImpl(
    _$DriverVehicleImpl _value,
    $Res Function(_$DriverVehicleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverVehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? plate = null,
    Object? seatCount = null,
    Object? vehicleType = null,
    Object? imageUrl = freezed,
    Object? year = null,
  }) {
    return _then(
      _$DriverVehicleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: null == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        plate: null == plate
            ? _value.plate
            : plate // ignore: cast_nullable_to_non_nullable
                  as String,
        seatCount: null == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        vehicleType: null == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverVehicleImpl implements _DriverVehicle {
  const _$DriverVehicleImpl({
    required this.id,
    this.brand = '',
    this.model = '',
    this.plate = '',
    this.seatCount = 0,
    this.vehicleType = '',
    this.imageUrl,
    this.year = 0,
  });

  factory _$DriverVehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverVehicleImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String brand;
  @override
  @JsonKey()
  final String model;
  @override
  @JsonKey()
  final String plate;
  @override
  @JsonKey()
  final int seatCount;
  @override
  @JsonKey()
  final String vehicleType;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int year;

  @override
  String toString() {
    return 'DriverVehicle(id: $id, brand: $brand, model: $model, plate: $plate, seatCount: $seatCount, vehicleType: $vehicleType, imageUrl: $imageUrl, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverVehicleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.year, year) || other.year == year));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    brand,
    model,
    plate,
    seatCount,
    vehicleType,
    imageUrl,
    year,
  );

  /// Create a copy of DriverVehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverVehicleImplCopyWith<_$DriverVehicleImpl> get copyWith =>
      __$$DriverVehicleImplCopyWithImpl<_$DriverVehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverVehicleImplToJson(this);
  }
}

abstract class _DriverVehicle implements DriverVehicle {
  const factory _DriverVehicle({
    required final String id,
    final String brand,
    final String model,
    final String plate,
    final int seatCount,
    final String vehicleType,
    final String? imageUrl,
    final int year,
  }) = _$DriverVehicleImpl;

  factory _DriverVehicle.fromJson(Map<String, dynamic> json) =
      _$DriverVehicleImpl.fromJson;

  @override
  String get id;
  @override
  String get brand;
  @override
  String get model;
  @override
  String get plate;
  @override
  int get seatCount;
  @override
  String get vehicleType;
  @override
  String? get imageUrl;
  @override
  int get year;

  /// Create a copy of DriverVehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverVehicleImplCopyWith<_$DriverVehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
