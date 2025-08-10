// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleResponse _$VehicleResponseFromJson(Map<String, dynamic> json) {
  return _VehicleResponse.fromJson(json);
}

/// @nodoc
mixin _$VehicleResponse {
  @JsonKey(name: 'vehicleDtos')
  VehicleDetail? get vehicleDtos => throw _privateConstructorUsedError;

  /// Serializes this VehicleResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleResponseCopyWith<VehicleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleResponseCopyWith<$Res> {
  factory $VehicleResponseCopyWith(
    VehicleResponse value,
    $Res Function(VehicleResponse) then,
  ) = _$VehicleResponseCopyWithImpl<$Res, VehicleResponse>;
  @useResult
  $Res call({@JsonKey(name: 'vehicleDtos') VehicleDetail? vehicleDtos});

  $VehicleDetailCopyWith<$Res>? get vehicleDtos;
}

/// @nodoc
class _$VehicleResponseCopyWithImpl<$Res, $Val extends VehicleResponse>
    implements $VehicleResponseCopyWith<$Res> {
  _$VehicleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicleDtos = freezed}) {
    return _then(
      _value.copyWith(
            vehicleDtos: freezed == vehicleDtos
                ? _value.vehicleDtos
                : vehicleDtos // ignore: cast_nullable_to_non_nullable
                      as VehicleDetail?,
          )
          as $Val,
    );
  }

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleDetailCopyWith<$Res>? get vehicleDtos {
    if (_value.vehicleDtos == null) {
      return null;
    }

    return $VehicleDetailCopyWith<$Res>(_value.vehicleDtos!, (value) {
      return _then(_value.copyWith(vehicleDtos: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VehicleResponseImplCopyWith<$Res>
    implements $VehicleResponseCopyWith<$Res> {
  factory _$$VehicleResponseImplCopyWith(
    _$VehicleResponseImpl value,
    $Res Function(_$VehicleResponseImpl) then,
  ) = __$$VehicleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'vehicleDtos') VehicleDetail? vehicleDtos});

  @override
  $VehicleDetailCopyWith<$Res>? get vehicleDtos;
}

/// @nodoc
class __$$VehicleResponseImplCopyWithImpl<$Res>
    extends _$VehicleResponseCopyWithImpl<$Res, _$VehicleResponseImpl>
    implements _$$VehicleResponseImplCopyWith<$Res> {
  __$$VehicleResponseImplCopyWithImpl(
    _$VehicleResponseImpl _value,
    $Res Function(_$VehicleResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicleDtos = freezed}) {
    return _then(
      _$VehicleResponseImpl(
        vehicleDtos: freezed == vehicleDtos
            ? _value.vehicleDtos
            : vehicleDtos // ignore: cast_nullable_to_non_nullable
                  as VehicleDetail?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleResponseImpl implements _VehicleResponse {
  const _$VehicleResponseImpl({
    @JsonKey(name: 'vehicleDtos') required this.vehicleDtos,
  });

  factory _$VehicleResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleResponseImplFromJson(json);

  @override
  @JsonKey(name: 'vehicleDtos')
  final VehicleDetail? vehicleDtos;

  @override
  String toString() {
    return 'VehicleResponse(vehicleDtos: $vehicleDtos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleResponseImpl &&
            (identical(other.vehicleDtos, vehicleDtos) ||
                other.vehicleDtos == vehicleDtos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vehicleDtos);

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleResponseImplCopyWith<_$VehicleResponseImpl> get copyWith =>
      __$$VehicleResponseImplCopyWithImpl<_$VehicleResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleResponseImplToJson(this);
  }
}

abstract class _VehicleResponse implements VehicleResponse {
  const factory _VehicleResponse({
    @JsonKey(name: 'vehicleDtos') required final VehicleDetail? vehicleDtos,
  }) = _$VehicleResponseImpl;

  factory _VehicleResponse.fromJson(Map<String, dynamic> json) =
      _$VehicleResponseImpl.fromJson;

  @override
  @JsonKey(name: 'vehicleDtos')
  VehicleDetail? get vehicleDtos;

  /// Create a copy of VehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleResponseImplCopyWith<_$VehicleResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
