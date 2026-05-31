// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_destination_list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PopularDestinationListDto _$PopularDestinationListDtoFromJson(
  Map<String, dynamic> json,
) {
  return _PopularDestinationListDto.fromJson(json);
}

/// @nodoc
mixin _$PopularDestinationListDto {
  @JsonKey(name: 'popularDestinations')
  List<PopularDestinationDto> get popularDestinations =>
      throw _privateConstructorUsedError;

  /// Serializes this PopularDestinationListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularDestinationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularDestinationListDtoCopyWith<PopularDestinationListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularDestinationListDtoCopyWith<$Res> {
  factory $PopularDestinationListDtoCopyWith(
    PopularDestinationListDto value,
    $Res Function(PopularDestinationListDto) then,
  ) = _$PopularDestinationListDtoCopyWithImpl<$Res, PopularDestinationListDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'popularDestinations')
    List<PopularDestinationDto> popularDestinations,
  });
}

/// @nodoc
class _$PopularDestinationListDtoCopyWithImpl<
  $Res,
  $Val extends PopularDestinationListDto
>
    implements $PopularDestinationListDtoCopyWith<$Res> {
  _$PopularDestinationListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularDestinationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? popularDestinations = null}) {
    return _then(
      _value.copyWith(
            popularDestinations: null == popularDestinations
                ? _value.popularDestinations
                : popularDestinations // ignore: cast_nullable_to_non_nullable
                      as List<PopularDestinationDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PopularDestinationListDtoImplCopyWith<$Res>
    implements $PopularDestinationListDtoCopyWith<$Res> {
  factory _$$PopularDestinationListDtoImplCopyWith(
    _$PopularDestinationListDtoImpl value,
    $Res Function(_$PopularDestinationListDtoImpl) then,
  ) = __$$PopularDestinationListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'popularDestinations')
    List<PopularDestinationDto> popularDestinations,
  });
}

/// @nodoc
class __$$PopularDestinationListDtoImplCopyWithImpl<$Res>
    extends
        _$PopularDestinationListDtoCopyWithImpl<
          $Res,
          _$PopularDestinationListDtoImpl
        >
    implements _$$PopularDestinationListDtoImplCopyWith<$Res> {
  __$$PopularDestinationListDtoImplCopyWithImpl(
    _$PopularDestinationListDtoImpl _value,
    $Res Function(_$PopularDestinationListDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopularDestinationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? popularDestinations = null}) {
    return _then(
      _$PopularDestinationListDtoImpl(
        popularDestinations: null == popularDestinations
            ? _value._popularDestinations
            : popularDestinations // ignore: cast_nullable_to_non_nullable
                  as List<PopularDestinationDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PopularDestinationListDtoImpl implements _PopularDestinationListDto {
  const _$PopularDestinationListDtoImpl({
    @JsonKey(name: 'popularDestinations')
    final List<PopularDestinationDto> popularDestinations = const [],
  }) : _popularDestinations = popularDestinations;

  factory _$PopularDestinationListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularDestinationListDtoImplFromJson(json);

  final List<PopularDestinationDto> _popularDestinations;
  @override
  @JsonKey(name: 'popularDestinations')
  List<PopularDestinationDto> get popularDestinations {
    if (_popularDestinations is EqualUnmodifiableListView)
      return _popularDestinations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularDestinations);
  }

  @override
  String toString() {
    return 'PopularDestinationListDto(popularDestinations: $popularDestinations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularDestinationListDtoImpl &&
            const DeepCollectionEquality().equals(
              other._popularDestinations,
              _popularDestinations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_popularDestinations),
  );

  /// Create a copy of PopularDestinationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularDestinationListDtoImplCopyWith<_$PopularDestinationListDtoImpl>
  get copyWith =>
      __$$PopularDestinationListDtoImplCopyWithImpl<
        _$PopularDestinationListDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularDestinationListDtoImplToJson(this);
  }
}

abstract class _PopularDestinationListDto implements PopularDestinationListDto {
  const factory _PopularDestinationListDto({
    @JsonKey(name: 'popularDestinations')
    final List<PopularDestinationDto> popularDestinations,
  }) = _$PopularDestinationListDtoImpl;

  factory _PopularDestinationListDto.fromJson(Map<String, dynamic> json) =
      _$PopularDestinationListDtoImpl.fromJson;

  @override
  @JsonKey(name: 'popularDestinations')
  List<PopularDestinationDto> get popularDestinations;

  /// Create a copy of PopularDestinationListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularDestinationListDtoImplCopyWith<_$PopularDestinationListDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
