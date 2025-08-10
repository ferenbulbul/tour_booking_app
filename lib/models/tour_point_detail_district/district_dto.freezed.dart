// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'district_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DistrictDto _$DistrictDtoFromJson(Map<String, dynamic> json) {
  return _DistrictDto.fromJson(json);
}

/// @nodoc
mixin _$DistrictDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;

  /// Serializes this DistrictDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistrictDtoCopyWith<DistrictDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistrictDtoCopyWith<$Res> {
  factory $DistrictDtoCopyWith(
    DistrictDto value,
    $Res Function(DistrictDto) then,
  ) = _$DistrictDtoCopyWithImpl<$Res, DistrictDto>;
  @useResult
  $Res call({String id, String name, String cityId});
}

/// @nodoc
class _$DistrictDtoCopyWithImpl<$Res, $Val extends DistrictDto>
    implements $DistrictDtoCopyWith<$Res> {
  _$DistrictDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? cityId = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DistrictDtoImplCopyWith<$Res>
    implements $DistrictDtoCopyWith<$Res> {
  factory _$$DistrictDtoImplCopyWith(
    _$DistrictDtoImpl value,
    $Res Function(_$DistrictDtoImpl) then,
  ) = __$$DistrictDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String cityId});
}

/// @nodoc
class __$$DistrictDtoImplCopyWithImpl<$Res>
    extends _$DistrictDtoCopyWithImpl<$Res, _$DistrictDtoImpl>
    implements _$$DistrictDtoImplCopyWith<$Res> {
  __$$DistrictDtoImplCopyWithImpl(
    _$DistrictDtoImpl _value,
    $Res Function(_$DistrictDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? cityId = null}) {
    return _then(
      _$DistrictDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DistrictDtoImpl implements _DistrictDto {
  const _$DistrictDtoImpl({
    required this.id,
    required this.name,
    required this.cityId,
  });

  factory _$DistrictDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistrictDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cityId;

  @override
  String toString() {
    return 'DistrictDto(id: $id, name: $name, cityId: $cityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistrictDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cityId, cityId) || other.cityId == cityId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cityId);

  /// Create a copy of DistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistrictDtoImplCopyWith<_$DistrictDtoImpl> get copyWith =>
      __$$DistrictDtoImplCopyWithImpl<_$DistrictDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistrictDtoImplToJson(this);
  }
}

abstract class _DistrictDto implements DistrictDto {
  const factory _DistrictDto({
    required final String id,
    required final String name,
    required final String cityId,
  }) = _$DistrictDtoImpl;

  factory _DistrictDto.fromJson(Map<String, dynamic> json) =
      _$DistrictDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cityId;

  /// Create a copy of DistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistrictDtoImplCopyWith<_$DistrictDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
