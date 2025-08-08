// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_tour_points_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileTourPointsResponse _$MobileTourPointsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MobileTourPointsResponse.fromJson(json);
}

/// @nodoc
mixin _$MobileTourPointsResponse {
  @JsonKey(name: 'tourPoints')
  List<MobileTourPointsBySearchDto> get tourPoints =>
      throw _privateConstructorUsedError;

  /// Serializes this MobileTourPointsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileTourPointsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileTourPointsResponseCopyWith<MobileTourPointsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileTourPointsResponseCopyWith<$Res> {
  factory $MobileTourPointsResponseCopyWith(
    MobileTourPointsResponse value,
    $Res Function(MobileTourPointsResponse) then,
  ) = _$MobileTourPointsResponseCopyWithImpl<$Res, MobileTourPointsResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'tourPoints') List<MobileTourPointsBySearchDto> tourPoints,
  });
}

/// @nodoc
class _$MobileTourPointsResponseCopyWithImpl<
  $Res,
  $Val extends MobileTourPointsResponse
>
    implements $MobileTourPointsResponseCopyWith<$Res> {
  _$MobileTourPointsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileTourPointsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _value.copyWith(
            tourPoints: null == tourPoints
                ? _value.tourPoints
                : tourPoints // ignore: cast_nullable_to_non_nullable
                      as List<MobileTourPointsBySearchDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileTourPointsResponseImplCopyWith<$Res>
    implements $MobileTourPointsResponseCopyWith<$Res> {
  factory _$$MobileTourPointsResponseImplCopyWith(
    _$MobileTourPointsResponseImpl value,
    $Res Function(_$MobileTourPointsResponseImpl) then,
  ) = __$$MobileTourPointsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'tourPoints') List<MobileTourPointsBySearchDto> tourPoints,
  });
}

/// @nodoc
class __$$MobileTourPointsResponseImplCopyWithImpl<$Res>
    extends
        _$MobileTourPointsResponseCopyWithImpl<
          $Res,
          _$MobileTourPointsResponseImpl
        >
    implements _$$MobileTourPointsResponseImplCopyWith<$Res> {
  __$$MobileTourPointsResponseImplCopyWithImpl(
    _$MobileTourPointsResponseImpl _value,
    $Res Function(_$MobileTourPointsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileTourPointsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _$MobileTourPointsResponseImpl(
        tourPoints: null == tourPoints
            ? _value._tourPoints
            : tourPoints // ignore: cast_nullable_to_non_nullable
                  as List<MobileTourPointsBySearchDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileTourPointsResponseImpl implements _MobileTourPointsResponse {
  const _$MobileTourPointsResponseImpl({
    @JsonKey(name: 'tourPoints')
    required final List<MobileTourPointsBySearchDto> tourPoints,
  }) : _tourPoints = tourPoints;

  factory _$MobileTourPointsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileTourPointsResponseImplFromJson(json);

  final List<MobileTourPointsBySearchDto> _tourPoints;
  @override
  @JsonKey(name: 'tourPoints')
  List<MobileTourPointsBySearchDto> get tourPoints {
    if (_tourPoints is EqualUnmodifiableListView) return _tourPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tourPoints);
  }

  @override
  String toString() {
    return 'MobileTourPointsResponse(tourPoints: $tourPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileTourPointsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._tourPoints,
              _tourPoints,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_tourPoints),
  );

  /// Create a copy of MobileTourPointsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileTourPointsResponseImplCopyWith<_$MobileTourPointsResponseImpl>
  get copyWith =>
      __$$MobileTourPointsResponseImplCopyWithImpl<
        _$MobileTourPointsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileTourPointsResponseImplToJson(this);
  }
}

abstract class _MobileTourPointsResponse implements MobileTourPointsResponse {
  const factory _MobileTourPointsResponse({
    @JsonKey(name: 'tourPoints')
    required final List<MobileTourPointsBySearchDto> tourPoints,
  }) = _$MobileTourPointsResponseImpl;

  factory _MobileTourPointsResponse.fromJson(Map<String, dynamic> json) =
      _$MobileTourPointsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'tourPoints')
  List<MobileTourPointsBySearchDto> get tourPoints;

  /// Create a copy of MobileTourPointsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileTourPointsResponseImplCopyWith<_$MobileTourPointsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
