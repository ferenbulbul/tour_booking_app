// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_tour_point_list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeaturedTourPointListDto _$FeaturedTourPointListDtoFromJson(
  Map<String, dynamic> json,
) {
  return _FeaturedTourPointListDto.fromJson(json);
}

/// @nodoc
mixin _$FeaturedTourPointListDto {
  @JsonKey(name: 'tourPoints')
  List<FeaturedTourPointDto> get tourPoints =>
      throw _privateConstructorUsedError;

  /// Serializes this FeaturedTourPointListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeaturedTourPointListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeaturedTourPointListDtoCopyWith<FeaturedTourPointListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeaturedTourPointListDtoCopyWith<$Res> {
  factory $FeaturedTourPointListDtoCopyWith(
    FeaturedTourPointListDto value,
    $Res Function(FeaturedTourPointListDto) then,
  ) = _$FeaturedTourPointListDtoCopyWithImpl<$Res, FeaturedTourPointListDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'tourPoints') List<FeaturedTourPointDto> tourPoints,
  });
}

/// @nodoc
class _$FeaturedTourPointListDtoCopyWithImpl<
  $Res,
  $Val extends FeaturedTourPointListDto
>
    implements $FeaturedTourPointListDtoCopyWith<$Res> {
  _$FeaturedTourPointListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeaturedTourPointListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _value.copyWith(
            tourPoints: null == tourPoints
                ? _value.tourPoints
                : tourPoints // ignore: cast_nullable_to_non_nullable
                      as List<FeaturedTourPointDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeaturedTourPointListDtoImplCopyWith<$Res>
    implements $FeaturedTourPointListDtoCopyWith<$Res> {
  factory _$$FeaturedTourPointListDtoImplCopyWith(
    _$FeaturedTourPointListDtoImpl value,
    $Res Function(_$FeaturedTourPointListDtoImpl) then,
  ) = __$$FeaturedTourPointListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'tourPoints') List<FeaturedTourPointDto> tourPoints,
  });
}

/// @nodoc
class __$$FeaturedTourPointListDtoImplCopyWithImpl<$Res>
    extends
        _$FeaturedTourPointListDtoCopyWithImpl<
          $Res,
          _$FeaturedTourPointListDtoImpl
        >
    implements _$$FeaturedTourPointListDtoImplCopyWith<$Res> {
  __$$FeaturedTourPointListDtoImplCopyWithImpl(
    _$FeaturedTourPointListDtoImpl _value,
    $Res Function(_$FeaturedTourPointListDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeaturedTourPointListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPoints = null}) {
    return _then(
      _$FeaturedTourPointListDtoImpl(
        tourPoints: null == tourPoints
            ? _value._tourPoints
            : tourPoints // ignore: cast_nullable_to_non_nullable
                  as List<FeaturedTourPointDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeaturedTourPointListDtoImpl implements _FeaturedTourPointListDto {
  const _$FeaturedTourPointListDtoImpl({
    @JsonKey(name: 'tourPoints')
    required final List<FeaturedTourPointDto> tourPoints,
  }) : _tourPoints = tourPoints;

  factory _$FeaturedTourPointListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeaturedTourPointListDtoImplFromJson(json);

  final List<FeaturedTourPointDto> _tourPoints;
  @override
  @JsonKey(name: 'tourPoints')
  List<FeaturedTourPointDto> get tourPoints {
    if (_tourPoints is EqualUnmodifiableListView) return _tourPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tourPoints);
  }

  @override
  String toString() {
    return 'FeaturedTourPointListDto(tourPoints: $tourPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeaturedTourPointListDtoImpl &&
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

  /// Create a copy of FeaturedTourPointListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeaturedTourPointListDtoImplCopyWith<_$FeaturedTourPointListDtoImpl>
  get copyWith =>
      __$$FeaturedTourPointListDtoImplCopyWithImpl<
        _$FeaturedTourPointListDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeaturedTourPointListDtoImplToJson(this);
  }
}

abstract class _FeaturedTourPointListDto implements FeaturedTourPointListDto {
  const factory _FeaturedTourPointListDto({
    @JsonKey(name: 'tourPoints')
    required final List<FeaturedTourPointDto> tourPoints,
  }) = _$FeaturedTourPointListDtoImpl;

  factory _FeaturedTourPointListDto.fromJson(Map<String, dynamic> json) =
      _$FeaturedTourPointListDtoImpl.fromJson;

  @override
  @JsonKey(name: 'tourPoints')
  List<FeaturedTourPointDto> get tourPoints;

  /// Create a copy of FeaturedTourPointListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeaturedTourPointListDtoImplCopyWith<_$FeaturedTourPointListDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
