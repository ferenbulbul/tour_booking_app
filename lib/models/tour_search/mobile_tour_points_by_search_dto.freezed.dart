// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_tour_points_by_search_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileTourPointsBySearchDto _$MobileTourPointsBySearchDtoFromJson(
  Map<String, dynamic> json,
) {
  return _MobileTourPointsBySearchDto.fromJson(json);
}

/// @nodoc
mixin _$MobileTourPointsBySearchDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this MobileTourPointsBySearchDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileTourPointsBySearchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileTourPointsBySearchDtoCopyWith<MobileTourPointsBySearchDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileTourPointsBySearchDtoCopyWith<$Res> {
  factory $MobileTourPointsBySearchDtoCopyWith(
    MobileTourPointsBySearchDto value,
    $Res Function(MobileTourPointsBySearchDto) then,
  ) =
      _$MobileTourPointsBySearchDtoCopyWithImpl<
        $Res,
        MobileTourPointsBySearchDto
      >;
  @useResult
  $Res call({String id, String name, String type});
}

/// @nodoc
class _$MobileTourPointsBySearchDtoCopyWithImpl<
  $Res,
  $Val extends MobileTourPointsBySearchDto
>
    implements $MobileTourPointsBySearchDtoCopyWith<$Res> {
  _$MobileTourPointsBySearchDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileTourPointsBySearchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? type = null}) {
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileTourPointsBySearchDtoImplCopyWith<$Res>
    implements $MobileTourPointsBySearchDtoCopyWith<$Res> {
  factory _$$MobileTourPointsBySearchDtoImplCopyWith(
    _$MobileTourPointsBySearchDtoImpl value,
    $Res Function(_$MobileTourPointsBySearchDtoImpl) then,
  ) = __$$MobileTourPointsBySearchDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String type});
}

/// @nodoc
class __$$MobileTourPointsBySearchDtoImplCopyWithImpl<$Res>
    extends
        _$MobileTourPointsBySearchDtoCopyWithImpl<
          $Res,
          _$MobileTourPointsBySearchDtoImpl
        >
    implements _$$MobileTourPointsBySearchDtoImplCopyWith<$Res> {
  __$$MobileTourPointsBySearchDtoImplCopyWithImpl(
    _$MobileTourPointsBySearchDtoImpl _value,
    $Res Function(_$MobileTourPointsBySearchDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileTourPointsBySearchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? type = null}) {
    return _then(
      _$MobileTourPointsBySearchDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileTourPointsBySearchDtoImpl
    implements _MobileTourPointsBySearchDto {
  const _$MobileTourPointsBySearchDtoImpl({
    required this.id,
    required this.name,
    required this.type,
  });

  factory _$MobileTourPointsBySearchDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MobileTourPointsBySearchDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;

  @override
  String toString() {
    return 'MobileTourPointsBySearchDto(id: $id, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileTourPointsBySearchDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type);

  /// Create a copy of MobileTourPointsBySearchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileTourPointsBySearchDtoImplCopyWith<_$MobileTourPointsBySearchDtoImpl>
  get copyWith =>
      __$$MobileTourPointsBySearchDtoImplCopyWithImpl<
        _$MobileTourPointsBySearchDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileTourPointsBySearchDtoImplToJson(this);
  }
}

abstract class _MobileTourPointsBySearchDto
    implements MobileTourPointsBySearchDto {
  const factory _MobileTourPointsBySearchDto({
    required final String id,
    required final String name,
    required final String type,
  }) = _$MobileTourPointsBySearchDtoImpl;

  factory _MobileTourPointsBySearchDto.fromJson(Map<String, dynamic> json) =
      _$MobileTourPointsBySearchDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;

  /// Create a copy of MobileTourPointsBySearchDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileTourPointsBySearchDtoImplCopyWith<_$MobileTourPointsBySearchDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
