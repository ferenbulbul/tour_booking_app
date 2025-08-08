// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileRegionListResponse _$MobileRegionListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MobileRegionListResponse.fromJson(json);
}

/// @nodoc
mixin _$MobileRegionListResponse {
  @JsonKey(name: 'regionList')
  List<MobileRegionDto> get regions => throw _privateConstructorUsedError;

  /// Serializes this MobileRegionListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileRegionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileRegionListResponseCopyWith<MobileRegionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileRegionListResponseCopyWith<$Res> {
  factory $MobileRegionListResponseCopyWith(
    MobileRegionListResponse value,
    $Res Function(MobileRegionListResponse) then,
  ) = _$MobileRegionListResponseCopyWithImpl<$Res, MobileRegionListResponse>;
  @useResult
  $Res call({@JsonKey(name: 'regionList') List<MobileRegionDto> regions});
}

/// @nodoc
class _$MobileRegionListResponseCopyWithImpl<
  $Res,
  $Val extends MobileRegionListResponse
>
    implements $MobileRegionListResponseCopyWith<$Res> {
  _$MobileRegionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileRegionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? regions = null}) {
    return _then(
      _value.copyWith(
            regions: null == regions
                ? _value.regions
                : regions // ignore: cast_nullable_to_non_nullable
                      as List<MobileRegionDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileRegionListResponseImplCopyWith<$Res>
    implements $MobileRegionListResponseCopyWith<$Res> {
  factory _$$MobileRegionListResponseImplCopyWith(
    _$MobileRegionListResponseImpl value,
    $Res Function(_$MobileRegionListResponseImpl) then,
  ) = __$$MobileRegionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'regionList') List<MobileRegionDto> regions});
}

/// @nodoc
class __$$MobileRegionListResponseImplCopyWithImpl<$Res>
    extends
        _$MobileRegionListResponseCopyWithImpl<
          $Res,
          _$MobileRegionListResponseImpl
        >
    implements _$$MobileRegionListResponseImplCopyWith<$Res> {
  __$$MobileRegionListResponseImplCopyWithImpl(
    _$MobileRegionListResponseImpl _value,
    $Res Function(_$MobileRegionListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileRegionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? regions = null}) {
    return _then(
      _$MobileRegionListResponseImpl(
        regions: null == regions
            ? _value._regions
            : regions // ignore: cast_nullable_to_non_nullable
                  as List<MobileRegionDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileRegionListResponseImpl implements _MobileRegionListResponse {
  const _$MobileRegionListResponseImpl({
    @JsonKey(name: 'regionList') required final List<MobileRegionDto> regions,
  }) : _regions = regions;

  factory _$MobileRegionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileRegionListResponseImplFromJson(json);

  final List<MobileRegionDto> _regions;
  @override
  @JsonKey(name: 'regionList')
  List<MobileRegionDto> get regions {
    if (_regions is EqualUnmodifiableListView) return _regions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_regions);
  }

  @override
  String toString() {
    return 'MobileRegionListResponse(regions: $regions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileRegionListResponseImpl &&
            const DeepCollectionEquality().equals(other._regions, _regions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_regions));

  /// Create a copy of MobileRegionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileRegionListResponseImplCopyWith<_$MobileRegionListResponseImpl>
  get copyWith =>
      __$$MobileRegionListResponseImplCopyWithImpl<
        _$MobileRegionListResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileRegionListResponseImplToJson(this);
  }
}

abstract class _MobileRegionListResponse implements MobileRegionListResponse {
  const factory _MobileRegionListResponse({
    @JsonKey(name: 'regionList') required final List<MobileRegionDto> regions,
  }) = _$MobileRegionListResponseImpl;

  factory _MobileRegionListResponse.fromJson(Map<String, dynamic> json) =
      _$MobileRegionListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'regionList')
  List<MobileRegionDto> get regions;

  /// Create a copy of MobileRegionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileRegionListResponseImplCopyWith<_$MobileRegionListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
