// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_detail_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleDetailRequest _$VehicleDetailRequestFromJson(Map<String, dynamic> json) {
  return _VehicleDetailRequest.fromJson(json);
}

/// @nodoc
mixin _$VehicleDetailRequest {
  String get vehicleId => throw _privateConstructorUsedError;
  String get tourRouteId => throw _privateConstructorUsedError;

  /// Serializes this VehicleDetailRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleDetailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleDetailRequestCopyWith<VehicleDetailRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleDetailRequestCopyWith<$Res> {
  factory $VehicleDetailRequestCopyWith(
    VehicleDetailRequest value,
    $Res Function(VehicleDetailRequest) then,
  ) = _$VehicleDetailRequestCopyWithImpl<$Res, VehicleDetailRequest>;
  @useResult
  $Res call({String vehicleId, String tourRouteId});
}

/// @nodoc
class _$VehicleDetailRequestCopyWithImpl<
  $Res,
  $Val extends VehicleDetailRequest
>
    implements $VehicleDetailRequestCopyWith<$Res> {
  _$VehicleDetailRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleDetailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicleId = null, Object? tourRouteId = null}) {
    return _then(
      _value.copyWith(
            vehicleId: null == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String,
            tourRouteId: null == tourRouteId
                ? _value.tourRouteId
                : tourRouteId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleDetailRequestImplCopyWith<$Res>
    implements $VehicleDetailRequestCopyWith<$Res> {
  factory _$$VehicleDetailRequestImplCopyWith(
    _$VehicleDetailRequestImpl value,
    $Res Function(_$VehicleDetailRequestImpl) then,
  ) = __$$VehicleDetailRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String vehicleId, String tourRouteId});
}

/// @nodoc
class __$$VehicleDetailRequestImplCopyWithImpl<$Res>
    extends _$VehicleDetailRequestCopyWithImpl<$Res, _$VehicleDetailRequestImpl>
    implements _$$VehicleDetailRequestImplCopyWith<$Res> {
  __$$VehicleDetailRequestImplCopyWithImpl(
    _$VehicleDetailRequestImpl _value,
    $Res Function(_$VehicleDetailRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleDetailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicleId = null, Object? tourRouteId = null}) {
    return _then(
      _$VehicleDetailRequestImpl(
        vehicleId: null == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String,
        tourRouteId: null == tourRouteId
            ? _value.tourRouteId
            : tourRouteId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleDetailRequestImpl implements _VehicleDetailRequest {
  const _$VehicleDetailRequestImpl({
    required this.vehicleId,
    required this.tourRouteId,
  });

  factory _$VehicleDetailRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleDetailRequestImplFromJson(json);

  @override
  final String vehicleId;
  @override
  final String tourRouteId;

  @override
  String toString() {
    return 'VehicleDetailRequest(vehicleId: $vehicleId, tourRouteId: $tourRouteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleDetailRequestImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.tourRouteId, tourRouteId) ||
                other.tourRouteId == tourRouteId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vehicleId, tourRouteId);

  /// Create a copy of VehicleDetailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleDetailRequestImplCopyWith<_$VehicleDetailRequestImpl>
  get copyWith =>
      __$$VehicleDetailRequestImplCopyWithImpl<_$VehicleDetailRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleDetailRequestImplToJson(this);
  }
}

abstract class _VehicleDetailRequest implements VehicleDetailRequest {
  const factory _VehicleDetailRequest({
    required final String vehicleId,
    required final String tourRouteId,
  }) = _$VehicleDetailRequestImpl;

  factory _VehicleDetailRequest.fromJson(Map<String, dynamic> json) =
      _$VehicleDetailRequestImpl.fromJson;

  @override
  String get vehicleId;
  @override
  String get tourRouteId;

  /// Create a copy of VehicleDetailRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleDetailRequestImplCopyWith<_$VehicleDetailRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
