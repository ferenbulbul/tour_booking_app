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

MobileDistrictDto _$MobileDistrictDtoFromJson(Map<String, dynamic> json) {
  return _MobileDistrictDto.fromJson(json);
}

/// @nodoc
mixin _$MobileDistrictDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this MobileDistrictDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileDistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileDistrictDtoCopyWith<MobileDistrictDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileDistrictDtoCopyWith<$Res> {
  factory $MobileDistrictDtoCopyWith(
    MobileDistrictDto value,
    $Res Function(MobileDistrictDto) then,
  ) = _$MobileDistrictDtoCopyWithImpl<$Res, MobileDistrictDto>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$MobileDistrictDtoCopyWithImpl<$Res, $Val extends MobileDistrictDto>
    implements $MobileDistrictDtoCopyWith<$Res> {
  _$MobileDistrictDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileDistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileDistrictDtoImplCopyWith<$Res>
    implements $MobileDistrictDtoCopyWith<$Res> {
  factory _$$MobileDistrictDtoImplCopyWith(
    _$MobileDistrictDtoImpl value,
    $Res Function(_$MobileDistrictDtoImpl) then,
  ) = __$$MobileDistrictDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$MobileDistrictDtoImplCopyWithImpl<$Res>
    extends _$MobileDistrictDtoCopyWithImpl<$Res, _$MobileDistrictDtoImpl>
    implements _$$MobileDistrictDtoImplCopyWith<$Res> {
  __$$MobileDistrictDtoImplCopyWithImpl(
    _$MobileDistrictDtoImpl _value,
    $Res Function(_$MobileDistrictDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileDistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$MobileDistrictDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileDistrictDtoImpl implements _MobileDistrictDto {
  const _$MobileDistrictDtoImpl({required this.id, required this.name});

  factory _$MobileDistrictDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileDistrictDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'MobileDistrictDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileDistrictDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of MobileDistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileDistrictDtoImplCopyWith<_$MobileDistrictDtoImpl> get copyWith =>
      __$$MobileDistrictDtoImplCopyWithImpl<_$MobileDistrictDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileDistrictDtoImplToJson(this);
  }
}

abstract class _MobileDistrictDto implements MobileDistrictDto {
  const factory _MobileDistrictDto({
    required final String id,
    required final String name,
  }) = _$MobileDistrictDtoImpl;

  factory _MobileDistrictDto.fromJson(Map<String, dynamic> json) =
      _$MobileDistrictDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of MobileDistrictDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileDistrictDtoImplCopyWith<_$MobileDistrictDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
