// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NearbyListResponse _$NearbyListResponseFromJson(Map<String, dynamic> json) {
  return _NearbyListResponse.fromJson(json);
}

/// @nodoc
mixin _$NearbyListResponse {
  List<NearbyTourPointDto> get nearByList => throw _privateConstructorUsedError;

  /// Serializes this NearbyListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbyListResponseCopyWith<NearbyListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyListResponseCopyWith<$Res> {
  factory $NearbyListResponseCopyWith(
    NearbyListResponse value,
    $Res Function(NearbyListResponse) then,
  ) = _$NearbyListResponseCopyWithImpl<$Res, NearbyListResponse>;
  @useResult
  $Res call({List<NearbyTourPointDto> nearByList});
}

/// @nodoc
class _$NearbyListResponseCopyWithImpl<$Res, $Val extends NearbyListResponse>
    implements $NearbyListResponseCopyWith<$Res> {
  _$NearbyListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nearByList = null}) {
    return _then(
      _value.copyWith(
            nearByList: null == nearByList
                ? _value.nearByList
                : nearByList // ignore: cast_nullable_to_non_nullable
                      as List<NearbyTourPointDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NearbyListResponseImplCopyWith<$Res>
    implements $NearbyListResponseCopyWith<$Res> {
  factory _$$NearbyListResponseImplCopyWith(
    _$NearbyListResponseImpl value,
    $Res Function(_$NearbyListResponseImpl) then,
  ) = __$$NearbyListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NearbyTourPointDto> nearByList});
}

/// @nodoc
class __$$NearbyListResponseImplCopyWithImpl<$Res>
    extends _$NearbyListResponseCopyWithImpl<$Res, _$NearbyListResponseImpl>
    implements _$$NearbyListResponseImplCopyWith<$Res> {
  __$$NearbyListResponseImplCopyWithImpl(
    _$NearbyListResponseImpl _value,
    $Res Function(_$NearbyListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NearbyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nearByList = null}) {
    return _then(
      _$NearbyListResponseImpl(
        nearByList: null == nearByList
            ? _value._nearByList
            : nearByList // ignore: cast_nullable_to_non_nullable
                  as List<NearbyTourPointDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyListResponseImpl implements _NearbyListResponse {
  const _$NearbyListResponseImpl({
    required final List<NearbyTourPointDto> nearByList,
  }) : _nearByList = nearByList;

  factory _$NearbyListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyListResponseImplFromJson(json);

  final List<NearbyTourPointDto> _nearByList;
  @override
  List<NearbyTourPointDto> get nearByList {
    if (_nearByList is EqualUnmodifiableListView) return _nearByList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearByList);
  }

  @override
  String toString() {
    return 'NearbyListResponse(nearByList: $nearByList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyListResponseImpl &&
            const DeepCollectionEquality().equals(
              other._nearByList,
              _nearByList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_nearByList),
  );

  /// Create a copy of NearbyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyListResponseImplCopyWith<_$NearbyListResponseImpl> get copyWith =>
      __$$NearbyListResponseImplCopyWithImpl<_$NearbyListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyListResponseImplToJson(this);
  }
}

abstract class _NearbyListResponse implements NearbyListResponse {
  const factory _NearbyListResponse({
    required final List<NearbyTourPointDto> nearByList,
  }) = _$NearbyListResponseImpl;

  factory _NearbyListResponse.fromJson(Map<String, dynamic> json) =
      _$NearbyListResponseImpl.fromJson;

  @override
  List<NearbyTourPointDto> get nearByList;

  /// Create a copy of NearbyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbyListResponseImplCopyWith<_$NearbyListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
