// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_destination_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PopularDestinationDto _$PopularDestinationDtoFromJson(
  Map<String, dynamic> json,
) {
  return _PopularDestinationDto.fromJson(json);
}

/// @nodoc
mixin _$PopularDestinationDto {
  String get id => throw _privateConstructorUsedError;
  String? get cityId => throw _privateConstructorUsedError;
  String? get cityName => throw _privateConstructorUsedError;
  String? get districtId => throw _privateConstructorUsedError;
  String? get districtName => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this PopularDestinationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularDestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularDestinationDtoCopyWith<PopularDestinationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularDestinationDtoCopyWith<$Res> {
  factory $PopularDestinationDtoCopyWith(
    PopularDestinationDto value,
    $Res Function(PopularDestinationDto) then,
  ) = _$PopularDestinationDtoCopyWithImpl<$Res, PopularDestinationDto>;
  @useResult
  $Res call({
    String id,
    String? cityId,
    String? cityName,
    String? districtId,
    String? districtName,
    String imageUrl,
    int displayOrder,
  });
}

/// @nodoc
class _$PopularDestinationDtoCopyWithImpl<
  $Res,
  $Val extends PopularDestinationDto
>
    implements $PopularDestinationDtoCopyWith<$Res> {
  _$PopularDestinationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularDestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cityId = freezed,
    Object? cityName = freezed,
    Object? districtId = freezed,
    Object? districtName = freezed,
    Object? imageUrl = null,
    Object? displayOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cityId: freezed == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cityName: freezed == cityName
                ? _value.cityName
                : cityName // ignore: cast_nullable_to_non_nullable
                      as String?,
            districtId: freezed == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String?,
            districtName: freezed == districtName
                ? _value.districtName
                : districtName // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            displayOrder: null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PopularDestinationDtoImplCopyWith<$Res>
    implements $PopularDestinationDtoCopyWith<$Res> {
  factory _$$PopularDestinationDtoImplCopyWith(
    _$PopularDestinationDtoImpl value,
    $Res Function(_$PopularDestinationDtoImpl) then,
  ) = __$$PopularDestinationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? cityId,
    String? cityName,
    String? districtId,
    String? districtName,
    String imageUrl,
    int displayOrder,
  });
}

/// @nodoc
class __$$PopularDestinationDtoImplCopyWithImpl<$Res>
    extends
        _$PopularDestinationDtoCopyWithImpl<$Res, _$PopularDestinationDtoImpl>
    implements _$$PopularDestinationDtoImplCopyWith<$Res> {
  __$$PopularDestinationDtoImplCopyWithImpl(
    _$PopularDestinationDtoImpl _value,
    $Res Function(_$PopularDestinationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopularDestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cityId = freezed,
    Object? cityName = freezed,
    Object? districtId = freezed,
    Object? districtName = freezed,
    Object? imageUrl = null,
    Object? displayOrder = null,
  }) {
    return _then(
      _$PopularDestinationDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cityId: freezed == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cityName: freezed == cityName
            ? _value.cityName
            : cityName // ignore: cast_nullable_to_non_nullable
                  as String?,
        districtId: freezed == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String?,
        districtName: freezed == districtName
            ? _value.districtName
            : districtName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        displayOrder: null == displayOrder
            ? _value.displayOrder
            : displayOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PopularDestinationDtoImpl implements _PopularDestinationDto {
  const _$PopularDestinationDtoImpl({
    required this.id,
    this.cityId,
    this.cityName,
    this.districtId,
    this.districtName,
    required this.imageUrl,
    required this.displayOrder,
  });

  factory _$PopularDestinationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularDestinationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String? cityId;
  @override
  final String? cityName;
  @override
  final String? districtId;
  @override
  final String? districtName;
  @override
  final String imageUrl;
  @override
  final int displayOrder;

  @override
  String toString() {
    return 'PopularDestinationDto(id: $id, cityId: $cityId, cityName: $cityName, districtId: $districtId, districtName: $districtName, imageUrl: $imageUrl, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularDestinationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.districtName, districtName) ||
                other.districtName == districtName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cityId,
    cityName,
    districtId,
    districtName,
    imageUrl,
    displayOrder,
  );

  /// Create a copy of PopularDestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularDestinationDtoImplCopyWith<_$PopularDestinationDtoImpl>
  get copyWith =>
      __$$PopularDestinationDtoImplCopyWithImpl<_$PopularDestinationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularDestinationDtoImplToJson(this);
  }
}

abstract class _PopularDestinationDto implements PopularDestinationDto {
  const factory _PopularDestinationDto({
    required final String id,
    final String? cityId,
    final String? cityName,
    final String? districtId,
    final String? districtName,
    required final String imageUrl,
    required final int displayOrder,
  }) = _$PopularDestinationDtoImpl;

  factory _PopularDestinationDto.fromJson(Map<String, dynamic> json) =
      _$PopularDestinationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String? get cityId;
  @override
  String? get cityName;
  @override
  String? get districtId;
  @override
  String? get districtName;
  @override
  String get imageUrl;
  @override
  int get displayOrder;

  /// Create a copy of PopularDestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularDestinationDtoImplCopyWith<_$PopularDestinationDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
