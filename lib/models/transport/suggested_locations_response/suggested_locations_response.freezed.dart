// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggested_locations_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportSuggestedLocationsResponse
_$TransportSuggestedLocationsResponseFromJson(Map<String, dynamic> json) {
  return _TransportSuggestedLocationsResponse.fromJson(json);
}

/// @nodoc
mixin _$TransportSuggestedLocationsResponse {
  List<TransportSuggestedLocation> get locations =>
      throw _privateConstructorUsedError;

  /// Serializes this TransportSuggestedLocationsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportSuggestedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportSuggestedLocationsResponseCopyWith<
    TransportSuggestedLocationsResponse
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportSuggestedLocationsResponseCopyWith<$Res> {
  factory $TransportSuggestedLocationsResponseCopyWith(
    TransportSuggestedLocationsResponse value,
    $Res Function(TransportSuggestedLocationsResponse) then,
  ) =
      _$TransportSuggestedLocationsResponseCopyWithImpl<
        $Res,
        TransportSuggestedLocationsResponse
      >;
  @useResult
  $Res call({List<TransportSuggestedLocation> locations});
}

/// @nodoc
class _$TransportSuggestedLocationsResponseCopyWithImpl<
  $Res,
  $Val extends TransportSuggestedLocationsResponse
>
    implements $TransportSuggestedLocationsResponseCopyWith<$Res> {
  _$TransportSuggestedLocationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportSuggestedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = null}) {
    return _then(
      _value.copyWith(
            locations: null == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as List<TransportSuggestedLocation>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportSuggestedLocationsResponseImplCopyWith<$Res>
    implements $TransportSuggestedLocationsResponseCopyWith<$Res> {
  factory _$$TransportSuggestedLocationsResponseImplCopyWith(
    _$TransportSuggestedLocationsResponseImpl value,
    $Res Function(_$TransportSuggestedLocationsResponseImpl) then,
  ) = __$$TransportSuggestedLocationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransportSuggestedLocation> locations});
}

/// @nodoc
class __$$TransportSuggestedLocationsResponseImplCopyWithImpl<$Res>
    extends
        _$TransportSuggestedLocationsResponseCopyWithImpl<
          $Res,
          _$TransportSuggestedLocationsResponseImpl
        >
    implements _$$TransportSuggestedLocationsResponseImplCopyWith<$Res> {
  __$$TransportSuggestedLocationsResponseImplCopyWithImpl(
    _$TransportSuggestedLocationsResponseImpl _value,
    $Res Function(_$TransportSuggestedLocationsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportSuggestedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? locations = null}) {
    return _then(
      _$TransportSuggestedLocationsResponseImpl(
        locations: null == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as List<TransportSuggestedLocation>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportSuggestedLocationsResponseImpl
    implements _TransportSuggestedLocationsResponse {
  const _$TransportSuggestedLocationsResponseImpl({
    final List<TransportSuggestedLocation> locations = const [],
  }) : _locations = locations;

  factory _$TransportSuggestedLocationsResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TransportSuggestedLocationsResponseImplFromJson(json);

  final List<TransportSuggestedLocation> _locations;
  @override
  @JsonKey()
  List<TransportSuggestedLocation> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  String toString() {
    return 'TransportSuggestedLocationsResponse(locations: $locations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportSuggestedLocationsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_locations));

  /// Create a copy of TransportSuggestedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportSuggestedLocationsResponseImplCopyWith<
    _$TransportSuggestedLocationsResponseImpl
  >
  get copyWith =>
      __$$TransportSuggestedLocationsResponseImplCopyWithImpl<
        _$TransportSuggestedLocationsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportSuggestedLocationsResponseImplToJson(this);
  }
}

abstract class _TransportSuggestedLocationsResponse
    implements TransportSuggestedLocationsResponse {
  const factory _TransportSuggestedLocationsResponse({
    final List<TransportSuggestedLocation> locations,
  }) = _$TransportSuggestedLocationsResponseImpl;

  factory _TransportSuggestedLocationsResponse.fromJson(
    Map<String, dynamic> json,
  ) = _$TransportSuggestedLocationsResponseImpl.fromJson;

  @override
  List<TransportSuggestedLocation> get locations;

  /// Create a copy of TransportSuggestedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportSuggestedLocationsResponseImplCopyWith<
    _$TransportSuggestedLocationsResponseImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
