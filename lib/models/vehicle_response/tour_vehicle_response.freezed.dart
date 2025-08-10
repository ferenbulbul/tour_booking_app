// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_vehicle_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourVehicleResponse _$TourVehicleResponseFromJson(Map<String, dynamic> json) {
  return _TourVehicleResponse.fromJson(json);
}

/// @nodoc
mixin _$TourVehicleResponse {
  List<Vehicle>? get vehicles => throw _privateConstructorUsedError;

  /// Serializes this TourVehicleResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourVehicleResponseCopyWith<TourVehicleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourVehicleResponseCopyWith<$Res> {
  factory $TourVehicleResponseCopyWith(
    TourVehicleResponse value,
    $Res Function(TourVehicleResponse) then,
  ) = _$TourVehicleResponseCopyWithImpl<$Res, TourVehicleResponse>;
  @useResult
  $Res call({List<Vehicle>? vehicles});
}

/// @nodoc
class _$TourVehicleResponseCopyWithImpl<$Res, $Val extends TourVehicleResponse>
    implements $TourVehicleResponseCopyWith<$Res> {
  _$TourVehicleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicles = freezed}) {
    return _then(
      _value.copyWith(
            vehicles: freezed == vehicles
                ? _value.vehicles
                : vehicles // ignore: cast_nullable_to_non_nullable
                      as List<Vehicle>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourVehicleResponseImplCopyWith<$Res>
    implements $TourVehicleResponseCopyWith<$Res> {
  factory _$$TourVehicleResponseImplCopyWith(
    _$TourVehicleResponseImpl value,
    $Res Function(_$TourVehicleResponseImpl) then,
  ) = __$$TourVehicleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Vehicle>? vehicles});
}

/// @nodoc
class __$$TourVehicleResponseImplCopyWithImpl<$Res>
    extends _$TourVehicleResponseCopyWithImpl<$Res, _$TourVehicleResponseImpl>
    implements _$$TourVehicleResponseImplCopyWith<$Res> {
  __$$TourVehicleResponseImplCopyWithImpl(
    _$TourVehicleResponseImpl _value,
    $Res Function(_$TourVehicleResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vehicles = freezed}) {
    return _then(
      _$TourVehicleResponseImpl(
        vehicles: freezed == vehicles
            ? _value._vehicles
            : vehicles // ignore: cast_nullable_to_non_nullable
                  as List<Vehicle>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourVehicleResponseImpl implements _TourVehicleResponse {
  const _$TourVehicleResponseImpl({final List<Vehicle>? vehicles})
    : _vehicles = vehicles;

  factory _$TourVehicleResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourVehicleResponseImplFromJson(json);

  final List<Vehicle>? _vehicles;
  @override
  List<Vehicle>? get vehicles {
    final value = _vehicles;
    if (value == null) return null;
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TourVehicleResponse(vehicles: $vehicles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourVehicleResponseImpl &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_vehicles));

  /// Create a copy of TourVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourVehicleResponseImplCopyWith<_$TourVehicleResponseImpl> get copyWith =>
      __$$TourVehicleResponseImplCopyWithImpl<_$TourVehicleResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourVehicleResponseImplToJson(this);
  }
}

abstract class _TourVehicleResponse implements TourVehicleResponse {
  const factory _TourVehicleResponse({final List<Vehicle>? vehicles}) =
      _$TourVehicleResponseImpl;

  factory _TourVehicleResponse.fromJson(Map<String, dynamic> json) =
      _$TourVehicleResponseImpl.fromJson;

  @override
  List<Vehicle>? get vehicles;

  /// Create a copy of TourVehicleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourVehicleResponseImplCopyWith<_$TourVehicleResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
