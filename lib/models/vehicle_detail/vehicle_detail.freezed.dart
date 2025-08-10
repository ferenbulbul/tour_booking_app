// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleDetail _$VehicleDetailFromJson(Map<String, dynamic> json) {
  return _VehicleDetail.fromJson(json);
}

/// @nodoc
mixin _$VehicleDetail {
  // JSON’da yoksa nullable yap
  String? get vehicleId => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError; // JSON’da var:
  String get vehicleBrand => throw _privateConstructorUsedError;
  String get vehicleClass => throw _privateConstructorUsedError;
  String get vehicleType => throw _privateConstructorUsedError;
  int get seatCount => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String? get legRoomSpace => throw _privateConstructorUsedError;
  String? get seatType => throw _privateConstructorUsedError;
  int? get modelYear => throw _privateConstructorUsedError;

  /// Serializes this VehicleDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleDetailCopyWith<VehicleDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleDetailCopyWith<$Res> {
  factory $VehicleDetailCopyWith(
    VehicleDetail value,
    $Res Function(VehicleDetail) then,
  ) = _$VehicleDetailCopyWithImpl<$Res, VehicleDetail>;
  @useResult
  $Res call({
    String? vehicleId,
    int? price,
    String vehicleBrand,
    String vehicleClass,
    String vehicleType,
    int seatCount,
    String image,
    String? legRoomSpace,
    String? seatType,
    int? modelYear,
  });
}

/// @nodoc
class _$VehicleDetailCopyWithImpl<$Res, $Val extends VehicleDetail>
    implements $VehicleDetailCopyWith<$Res> {
  _$VehicleDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = freezed,
    Object? price = freezed,
    Object? vehicleBrand = null,
    Object? vehicleClass = null,
    Object? vehicleType = null,
    Object? seatCount = null,
    Object? image = null,
    Object? legRoomSpace = freezed,
    Object? seatType = freezed,
    Object? modelYear = freezed,
  }) {
    return _then(
      _value.copyWith(
            vehicleId: freezed == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int?,
            vehicleBrand: null == vehicleBrand
                ? _value.vehicleBrand
                : vehicleBrand // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleClass: null == vehicleClass
                ? _value.vehicleClass
                : vehicleClass // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleType: null == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as String,
            seatCount: null == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            legRoomSpace: freezed == legRoomSpace
                ? _value.legRoomSpace
                : legRoomSpace // ignore: cast_nullable_to_non_nullable
                      as String?,
            seatType: freezed == seatType
                ? _value.seatType
                : seatType // ignore: cast_nullable_to_non_nullable
                      as String?,
            modelYear: freezed == modelYear
                ? _value.modelYear
                : modelYear // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleDetailImplCopyWith<$Res>
    implements $VehicleDetailCopyWith<$Res> {
  factory _$$VehicleDetailImplCopyWith(
    _$VehicleDetailImpl value,
    $Res Function(_$VehicleDetailImpl) then,
  ) = __$$VehicleDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? vehicleId,
    int? price,
    String vehicleBrand,
    String vehicleClass,
    String vehicleType,
    int seatCount,
    String image,
    String? legRoomSpace,
    String? seatType,
    int? modelYear,
  });
}

/// @nodoc
class __$$VehicleDetailImplCopyWithImpl<$Res>
    extends _$VehicleDetailCopyWithImpl<$Res, _$VehicleDetailImpl>
    implements _$$VehicleDetailImplCopyWith<$Res> {
  __$$VehicleDetailImplCopyWithImpl(
    _$VehicleDetailImpl _value,
    $Res Function(_$VehicleDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = freezed,
    Object? price = freezed,
    Object? vehicleBrand = null,
    Object? vehicleClass = null,
    Object? vehicleType = null,
    Object? seatCount = null,
    Object? image = null,
    Object? legRoomSpace = freezed,
    Object? seatType = freezed,
    Object? modelYear = freezed,
  }) {
    return _then(
      _$VehicleDetailImpl(
        vehicleId: freezed == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int?,
        vehicleBrand: null == vehicleBrand
            ? _value.vehicleBrand
            : vehicleBrand // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleClass: null == vehicleClass
            ? _value.vehicleClass
            : vehicleClass // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleType: null == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as String,
        seatCount: null == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        legRoomSpace: freezed == legRoomSpace
            ? _value.legRoomSpace
            : legRoomSpace // ignore: cast_nullable_to_non_nullable
                  as String?,
        seatType: freezed == seatType
            ? _value.seatType
            : seatType // ignore: cast_nullable_to_non_nullable
                  as String?,
        modelYear: freezed == modelYear
            ? _value.modelYear
            : modelYear // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleDetailImpl implements _VehicleDetail {
  const _$VehicleDetailImpl({
    this.vehicleId,
    this.price,
    required this.vehicleBrand,
    required this.vehicleClass,
    required this.vehicleType,
    required this.seatCount,
    required this.image,
    this.legRoomSpace,
    this.seatType,
    this.modelYear,
  });

  factory _$VehicleDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleDetailImplFromJson(json);

  // JSON’da yoksa nullable yap
  @override
  final String? vehicleId;
  @override
  final int? price;
  // JSON’da var:
  @override
  final String vehicleBrand;
  @override
  final String vehicleClass;
  @override
  final String vehicleType;
  @override
  final int seatCount;
  @override
  final String image;
  @override
  final String? legRoomSpace;
  @override
  final String? seatType;
  @override
  final int? modelYear;

  @override
  String toString() {
    return 'VehicleDetail(vehicleId: $vehicleId, price: $price, vehicleBrand: $vehicleBrand, vehicleClass: $vehicleClass, vehicleType: $vehicleType, seatCount: $seatCount, image: $image, legRoomSpace: $legRoomSpace, seatType: $seatType, modelYear: $modelYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleDetailImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.vehicleBrand, vehicleBrand) ||
                other.vehicleBrand == vehicleBrand) &&
            (identical(other.vehicleClass, vehicleClass) ||
                other.vehicleClass == vehicleClass) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.legRoomSpace, legRoomSpace) ||
                other.legRoomSpace == legRoomSpace) &&
            (identical(other.seatType, seatType) ||
                other.seatType == seatType) &&
            (identical(other.modelYear, modelYear) ||
                other.modelYear == modelYear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    vehicleId,
    price,
    vehicleBrand,
    vehicleClass,
    vehicleType,
    seatCount,
    image,
    legRoomSpace,
    seatType,
    modelYear,
  );

  /// Create a copy of VehicleDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleDetailImplCopyWith<_$VehicleDetailImpl> get copyWith =>
      __$$VehicleDetailImplCopyWithImpl<_$VehicleDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleDetailImplToJson(this);
  }
}

abstract class _VehicleDetail implements VehicleDetail {
  const factory _VehicleDetail({
    final String? vehicleId,
    final int? price,
    required final String vehicleBrand,
    required final String vehicleClass,
    required final String vehicleType,
    required final int seatCount,
    required final String image,
    final String? legRoomSpace,
    final String? seatType,
    final int? modelYear,
  }) = _$VehicleDetailImpl;

  factory _VehicleDetail.fromJson(Map<String, dynamic> json) =
      _$VehicleDetailImpl.fromJson;

  // JSON’da yoksa nullable yap
  @override
  String? get vehicleId;
  @override
  int? get price; // JSON’da var:
  @override
  String get vehicleBrand;
  @override
  String get vehicleClass;
  @override
  String get vehicleType;
  @override
  int get seatCount;
  @override
  String get image;
  @override
  String? get legRoomSpace;
  @override
  String? get seatType;
  @override
  int? get modelYear;

  /// Create a copy of VehicleDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleDetailImplCopyWith<_$VehicleDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
