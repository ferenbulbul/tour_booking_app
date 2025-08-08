// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourSearchResponse _$TourSearchResponseFromJson(Map<String, dynamic> json) {
  return _TourSearchResponse.fromJson(json);
}

/// @nodoc
mixin _$TourSearchResponse {
  List<TourPoint> get tourPoints => throw _privateConstructorUsedError;

  /// Serializes this TourSearchResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourSearchResponseCopyWith<TourSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourSearchResponseCopyWith<$Res> {
  factory $TourSearchResponseCopyWith(
    TourSearchResponse value,
    $Res Function(TourSearchResponse) then,
  ) = _$TourSearchResponseCopyWithImpl<$Res, TourSearchResponse>;
  @useResult
  $Res call({List<TourPoint> tourPoints});
}

/// @nodoc
class _$TourSearchResponseCopyWithImpl<$Res, $Val extends TourSearchResponse>
    implements $TourSearchResponseCopyWith<$Res> {
  _$TourSearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _value.copyWith(
            tourPoints: null == tourPoints
                ? _value.tourPoints
                : tourPoints // ignore: cast_nullable_to_non_nullable
                      as List<TourPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourSearchResponseImplCopyWith<$Res>
    implements $TourSearchResponseCopyWith<$Res> {
  factory _$$TourSearchResponseImplCopyWith(
    _$TourSearchResponseImpl value,
    $Res Function(_$TourSearchResponseImpl) then,
  ) = __$$TourSearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TourPoint> tourPoints});
}

/// @nodoc
class __$$TourSearchResponseImplCopyWithImpl<$Res>
    extends _$TourSearchResponseCopyWithImpl<$Res, _$TourSearchResponseImpl>
    implements _$$TourSearchResponseImplCopyWith<$Res> {
  __$$TourSearchResponseImplCopyWithImpl(
    _$TourSearchResponseImpl _value,
    $Res Function(_$TourSearchResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _$TourSearchResponseImpl(
        tourPoints: null == tourPoints
            ? _value._tourPoints
            : tourPoints // ignore: cast_nullable_to_non_nullable
                  as List<TourPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourSearchResponseImpl implements _TourSearchResponse {
  const _$TourSearchResponseImpl({required final List<TourPoint> tourPoints})
    : _tourPoints = tourPoints;

  factory _$TourSearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourSearchResponseImplFromJson(json);

  final List<TourPoint> _tourPoints;
  @override
  List<TourPoint> get tourPoints {
    if (_tourPoints is EqualUnmodifiableListView) return _tourPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tourPoints);
  }

  @override
  String toString() {
    return 'TourSearchResponse(tourPoints: $tourPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourSearchResponseImpl &&
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

  /// Create a copy of TourSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourSearchResponseImplCopyWith<_$TourSearchResponseImpl> get copyWith =>
      __$$TourSearchResponseImplCopyWithImpl<_$TourSearchResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourSearchResponseImplToJson(this);
  }
}

abstract class _TourSearchResponse implements TourSearchResponse {
  const factory _TourSearchResponse({
    required final List<TourPoint> tourPoints,
  }) = _$TourSearchResponseImpl;

  factory _TourSearchResponse.fromJson(Map<String, dynamic> json) =
      _$TourSearchResponseImpl.fromJson;

  @override
  List<TourPoint> get tourPoints;

  /// Create a copy of TourSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourSearchResponseImplCopyWith<_$TourSearchResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
