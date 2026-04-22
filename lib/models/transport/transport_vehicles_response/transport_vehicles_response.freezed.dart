// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_vehicles_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportVehiclesResponse _$TransportVehiclesResponseFromJson(
  Map<String, dynamic> json,
) {
  return _TransportVehiclesResponse.fromJson(json);
}

/// @nodoc
mixin _$TransportVehiclesResponse {
  List<TransportVehicle> get vehicles => throw _privateConstructorUsedError;

  /// Serializes this TransportVehiclesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportVehiclesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportVehiclesResponseCopyWith<TransportVehiclesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportVehiclesResponseCopyWith<$Res> {
  factory $TransportVehiclesResponseCopyWith(
    TransportVehiclesResponse value,
    $Res Function(TransportVehiclesResponse) then,
  ) = _$TransportVehiclesResponseCopyWithImpl<$Res, TransportVehiclesResponse>;
  @useResult
  $Res call({List<TransportVehicle> vehicles});
}

/// @nodoc
class _$TransportVehiclesResponseCopyWithImpl<
  $Res,
  $Val extends TransportVehiclesResponse
>
    implements $TransportVehiclesResponseCopyWith<$Res> {
  _$TransportVehiclesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportVehiclesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicles = null}) {
    return _then(
      _value.copyWith(
            vehicles: null == vehicles
                ? _value.vehicles
                : vehicles // ignore: cast_nullable_to_non_nullable
                      as List<TransportVehicle>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportVehiclesResponseImplCopyWith<$Res>
    implements $TransportVehiclesResponseCopyWith<$Res> {
  factory _$$TransportVehiclesResponseImplCopyWith(
    _$TransportVehiclesResponseImpl value,
    $Res Function(_$TransportVehiclesResponseImpl) then,
  ) = __$$TransportVehiclesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransportVehicle> vehicles});
}

/// @nodoc
class __$$TransportVehiclesResponseImplCopyWithImpl<$Res>
    extends
        _$TransportVehiclesResponseCopyWithImpl<
          $Res,
          _$TransportVehiclesResponseImpl
        >
    implements _$$TransportVehiclesResponseImplCopyWith<$Res> {
  __$$TransportVehiclesResponseImplCopyWithImpl(
    _$TransportVehiclesResponseImpl _value,
    $Res Function(_$TransportVehiclesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportVehiclesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicles = null}) {
    return _then(
      _$TransportVehiclesResponseImpl(
        vehicles: null == vehicles
            ? _value._vehicles
            : vehicles // ignore: cast_nullable_to_non_nullable
                  as List<TransportVehicle>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportVehiclesResponseImpl implements _TransportVehiclesResponse {
  const _$TransportVehiclesResponseImpl({
    final List<TransportVehicle> vehicles = const [],
  }) : _vehicles = vehicles;

  factory _$TransportVehiclesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportVehiclesResponseImplFromJson(json);

  final List<TransportVehicle> _vehicles;
  @override
  @JsonKey()
  List<TransportVehicle> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  String toString() {
    return 'TransportVehiclesResponse(vehicles: $vehicles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportVehiclesResponseImpl &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_vehicles));

  /// Create a copy of TransportVehiclesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportVehiclesResponseImplCopyWith<_$TransportVehiclesResponseImpl>
  get copyWith =>
      __$$TransportVehiclesResponseImplCopyWithImpl<
        _$TransportVehiclesResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportVehiclesResponseImplToJson(this);
  }
}

abstract class _TransportVehiclesResponse implements TransportVehiclesResponse {
  const factory _TransportVehiclesResponse({
    final List<TransportVehicle> vehicles,
  }) = _$TransportVehiclesResponseImpl;

  factory _TransportVehiclesResponse.fromJson(Map<String, dynamic> json) =
      _$TransportVehiclesResponseImpl.fromJson;

  @override
  List<TransportVehicle> get vehicles;

  /// Create a copy of TransportVehiclesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportVehiclesResponseImplCopyWith<_$TransportVehiclesResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
