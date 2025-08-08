// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'district_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileDistrictListResponse _$MobileDistrictListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MobileDistrictListResponse.fromJson(json);
}

/// @nodoc
mixin _$MobileDistrictListResponse {
  @JsonKey(name: 'districtList')
  List<MobileDistrictDto> get districts => throw _privateConstructorUsedError;

  /// Serializes this MobileDistrictListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileDistrictListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileDistrictListResponseCopyWith<MobileDistrictListResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileDistrictListResponseCopyWith<$Res> {
  factory $MobileDistrictListResponseCopyWith(
    MobileDistrictListResponse value,
    $Res Function(MobileDistrictListResponse) then,
  ) =
      _$MobileDistrictListResponseCopyWithImpl<
        $Res,
        MobileDistrictListResponse
      >;
  @useResult
  $Res call({@JsonKey(name: 'districtList') List<MobileDistrictDto> districts});
}

/// @nodoc
class _$MobileDistrictListResponseCopyWithImpl<
  $Res,
  $Val extends MobileDistrictListResponse
>
    implements $MobileDistrictListResponseCopyWith<$Res> {
  _$MobileDistrictListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileDistrictListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? districts = null}) {
    return _then(
      _value.copyWith(
            districts: null == districts
                ? _value.districts
                : districts // ignore: cast_nullable_to_non_nullable
                      as List<MobileDistrictDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileDistrictListResponseImplCopyWith<$Res>
    implements $MobileDistrictListResponseCopyWith<$Res> {
  factory _$$MobileDistrictListResponseImplCopyWith(
    _$MobileDistrictListResponseImpl value,
    $Res Function(_$MobileDistrictListResponseImpl) then,
  ) = __$$MobileDistrictListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'districtList') List<MobileDistrictDto> districts});
}

/// @nodoc
class __$$MobileDistrictListResponseImplCopyWithImpl<$Res>
    extends
        _$MobileDistrictListResponseCopyWithImpl<
          $Res,
          _$MobileDistrictListResponseImpl
        >
    implements _$$MobileDistrictListResponseImplCopyWith<$Res> {
  __$$MobileDistrictListResponseImplCopyWithImpl(
    _$MobileDistrictListResponseImpl _value,
    $Res Function(_$MobileDistrictListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileDistrictListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? districts = null}) {
    return _then(
      _$MobileDistrictListResponseImpl(
        districts: null == districts
            ? _value._districts
            : districts // ignore: cast_nullable_to_non_nullable
                  as List<MobileDistrictDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileDistrictListResponseImpl implements _MobileDistrictListResponse {
  const _$MobileDistrictListResponseImpl({
    @JsonKey(name: 'districtList')
    required final List<MobileDistrictDto> districts,
  }) : _districts = districts;

  factory _$MobileDistrictListResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MobileDistrictListResponseImplFromJson(json);

  final List<MobileDistrictDto> _districts;
  @override
  @JsonKey(name: 'districtList')
  List<MobileDistrictDto> get districts {
    if (_districts is EqualUnmodifiableListView) return _districts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_districts);
  }

  @override
  String toString() {
    return 'MobileDistrictListResponse(districts: $districts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileDistrictListResponseImpl &&
            const DeepCollectionEquality().equals(
              other._districts,
              _districts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_districts));

  /// Create a copy of MobileDistrictListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileDistrictListResponseImplCopyWith<_$MobileDistrictListResponseImpl>
  get copyWith =>
      __$$MobileDistrictListResponseImplCopyWithImpl<
        _$MobileDistrictListResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileDistrictListResponseImplToJson(this);
  }
}

abstract class _MobileDistrictListResponse
    implements MobileDistrictListResponse {
  const factory _MobileDistrictListResponse({
    @JsonKey(name: 'districtList')
    required final List<MobileDistrictDto> districts,
  }) = _$MobileDistrictListResponseImpl;

  factory _MobileDistrictListResponse.fromJson(Map<String, dynamic> json) =
      _$MobileDistrictListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'districtList')
  List<MobileDistrictDto> get districts;

  /// Create a copy of MobileDistrictListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileDistrictListResponseImplCopyWith<_$MobileDistrictListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
