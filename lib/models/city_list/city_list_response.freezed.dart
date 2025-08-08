// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'city_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileCityListResponse _$MobileCityListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MobileCityListResponse.fromJson(json);
}

/// @nodoc
mixin _$MobileCityListResponse {
  @JsonKey(name: 'cityList')
  List<MobileCityDto> get cities => throw _privateConstructorUsedError;

  /// Serializes this MobileCityListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileCityListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileCityListResponseCopyWith<MobileCityListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileCityListResponseCopyWith<$Res> {
  factory $MobileCityListResponseCopyWith(
    MobileCityListResponse value,
    $Res Function(MobileCityListResponse) then,
  ) = _$MobileCityListResponseCopyWithImpl<$Res, MobileCityListResponse>;
  @useResult
  $Res call({@JsonKey(name: 'cityList') List<MobileCityDto> cities});
}

/// @nodoc
class _$MobileCityListResponseCopyWithImpl<
  $Res,
  $Val extends MobileCityListResponse
>
    implements $MobileCityListResponseCopyWith<$Res> {
  _$MobileCityListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileCityListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cities = null}) {
    return _then(
      _value.copyWith(
            cities: null == cities
                ? _value.cities
                : cities // ignore: cast_nullable_to_non_nullable
                      as List<MobileCityDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileCityListResponseImplCopyWith<$Res>
    implements $MobileCityListResponseCopyWith<$Res> {
  factory _$$MobileCityListResponseImplCopyWith(
    _$MobileCityListResponseImpl value,
    $Res Function(_$MobileCityListResponseImpl) then,
  ) = __$$MobileCityListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'cityList') List<MobileCityDto> cities});
}

/// @nodoc
class __$$MobileCityListResponseImplCopyWithImpl<$Res>
    extends
        _$MobileCityListResponseCopyWithImpl<$Res, _$MobileCityListResponseImpl>
    implements _$$MobileCityListResponseImplCopyWith<$Res> {
  __$$MobileCityListResponseImplCopyWithImpl(
    _$MobileCityListResponseImpl _value,
    $Res Function(_$MobileCityListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileCityListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cities = null}) {
    return _then(
      _$MobileCityListResponseImpl(
        cities: null == cities
            ? _value._cities
            : cities // ignore: cast_nullable_to_non_nullable
                  as List<MobileCityDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileCityListResponseImpl implements _MobileCityListResponse {
  const _$MobileCityListResponseImpl({
    @JsonKey(name: 'cityList') required final List<MobileCityDto> cities,
  }) : _cities = cities;

  factory _$MobileCityListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileCityListResponseImplFromJson(json);

  final List<MobileCityDto> _cities;
  @override
  @JsonKey(name: 'cityList')
  List<MobileCityDto> get cities {
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cities);
  }

  @override
  String toString() {
    return 'MobileCityListResponse(cities: $cities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileCityListResponseImpl &&
            const DeepCollectionEquality().equals(other._cities, _cities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cities));

  /// Create a copy of MobileCityListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileCityListResponseImplCopyWith<_$MobileCityListResponseImpl>
  get copyWith =>
      __$$MobileCityListResponseImplCopyWithImpl<_$MobileCityListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileCityListResponseImplToJson(this);
  }
}

abstract class _MobileCityListResponse implements MobileCityListResponse {
  const factory _MobileCityListResponse({
    @JsonKey(name: 'cityList') required final List<MobileCityDto> cities,
  }) = _$MobileCityListResponseImpl;

  factory _MobileCityListResponse.fromJson(Map<String, dynamic> json) =
      _$MobileCityListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'cityList')
  List<MobileCityDto> get cities;

  /// Create a copy of MobileCityListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileCityListResponseImplCopyWith<_$MobileCityListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
