// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_types_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourTypesDto _$TourTypesDtoFromJson(Map<String, dynamic> json) {
  return _TourTypesDto.fromJson(json);
}

/// @nodoc
mixin _$TourTypesDto {
  @JsonKey(name: 'tourTypes')
  List<TourTypeDto> get tourTypes => throw _privateConstructorUsedError;

  /// Serializes this TourTypesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourTypesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourTypesDtoCopyWith<TourTypesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourTypesDtoCopyWith<$Res> {
  factory $TourTypesDtoCopyWith(
    TourTypesDto value,
    $Res Function(TourTypesDto) then,
  ) = _$TourTypesDtoCopyWithImpl<$Res, TourTypesDto>;
  @useResult
  $Res call({@JsonKey(name: 'tourTypes') List<TourTypeDto> tourTypes});
}

/// @nodoc
class _$TourTypesDtoCopyWithImpl<$Res, $Val extends TourTypesDto>
    implements $TourTypesDtoCopyWith<$Res> {
  _$TourTypesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourTypesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourTypes = null}) {
    return _then(
      _value.copyWith(
            tourTypes: null == tourTypes
                ? _value.tourTypes
                : tourTypes // ignore: cast_nullable_to_non_nullable
                      as List<TourTypeDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourTypesDtoImplCopyWith<$Res>
    implements $TourTypesDtoCopyWith<$Res> {
  factory _$$TourTypesDtoImplCopyWith(
    _$TourTypesDtoImpl value,
    $Res Function(_$TourTypesDtoImpl) then,
  ) = __$$TourTypesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'tourTypes') List<TourTypeDto> tourTypes});
}

/// @nodoc
class __$$TourTypesDtoImplCopyWithImpl<$Res>
    extends _$TourTypesDtoCopyWithImpl<$Res, _$TourTypesDtoImpl>
    implements _$$TourTypesDtoImplCopyWith<$Res> {
  __$$TourTypesDtoImplCopyWithImpl(
    _$TourTypesDtoImpl _value,
    $Res Function(_$TourTypesDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourTypesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourTypes = null}) {
    return _then(
      _$TourTypesDtoImpl(
        tourTypes: null == tourTypes
            ? _value._tourTypes
            : tourTypes // ignore: cast_nullable_to_non_nullable
                  as List<TourTypeDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourTypesDtoImpl implements _TourTypesDto {
  const _$TourTypesDtoImpl({
    @JsonKey(name: 'tourTypes') required final List<TourTypeDto> tourTypes,
  }) : _tourTypes = tourTypes;

  factory _$TourTypesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourTypesDtoImplFromJson(json);

  final List<TourTypeDto> _tourTypes;
  @override
  @JsonKey(name: 'tourTypes')
  List<TourTypeDto> get tourTypes {
    if (_tourTypes is EqualUnmodifiableListView) return _tourTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tourTypes);
  }

  @override
  String toString() {
    return 'TourTypesDto(tourTypes: $tourTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourTypesDtoImpl &&
            const DeepCollectionEquality().equals(
              other._tourTypes,
              _tourTypes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tourTypes));

  /// Create a copy of TourTypesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourTypesDtoImplCopyWith<_$TourTypesDtoImpl> get copyWith =>
      __$$TourTypesDtoImplCopyWithImpl<_$TourTypesDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TourTypesDtoImplToJson(this);
  }
}

abstract class _TourTypesDto implements TourTypesDto {
  const factory _TourTypesDto({
    @JsonKey(name: 'tourTypes') required final List<TourTypeDto> tourTypes,
  }) = _$TourTypesDtoImpl;

  factory _TourTypesDto.fromJson(Map<String, dynamic> json) =
      _$TourTypesDtoImpl.fromJson;

  @override
  @JsonKey(name: 'tourTypes')
  List<TourTypeDto> get tourTypes;

  /// Create a copy of TourTypesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourTypesDtoImplCopyWith<_$TourTypesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
