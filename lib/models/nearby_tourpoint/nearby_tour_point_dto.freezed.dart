// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_tour_point_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NearbyTourPointDto _$NearbyTourPointDtoFromJson(Map<String, dynamic> json) {
  return _NearbyTourPointDto.fromJson(json);
}

/// @nodoc
mixin _$NearbyTourPointDto {
  String get id => throw _privateConstructorUsedError;
  String get cityName => throw _privateConstructorUsedError;
  String get tourTypeName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get mainImage => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;

  /// Serializes this NearbyTourPointDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbyTourPointDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbyTourPointDtoCopyWith<NearbyTourPointDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyTourPointDtoCopyWith<$Res> {
  factory $NearbyTourPointDtoCopyWith(
    NearbyTourPointDto value,
    $Res Function(NearbyTourPointDto) then,
  ) = _$NearbyTourPointDtoCopyWithImpl<$Res, NearbyTourPointDto>;
  @useResult
  $Res call({
    String id,
    String cityName,
    String tourTypeName,
    String title,
    String mainImage,
    double distance,
  });
}

/// @nodoc
class _$NearbyTourPointDtoCopyWithImpl<$Res, $Val extends NearbyTourPointDto>
    implements $NearbyTourPointDtoCopyWith<$Res> {
  _$NearbyTourPointDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbyTourPointDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cityName = null,
    Object? tourTypeName = null,
    Object? title = null,
    Object? mainImage = null,
    Object? distance = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cityName: null == cityName
                ? _value.cityName
                : cityName // ignore: cast_nullable_to_non_nullable
                      as String,
            tourTypeName: null == tourTypeName
                ? _value.tourTypeName
                : tourTypeName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            mainImage: null == mainImage
                ? _value.mainImage
                : mainImage // ignore: cast_nullable_to_non_nullable
                      as String,
            distance: null == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NearbyTourPointDtoImplCopyWith<$Res>
    implements $NearbyTourPointDtoCopyWith<$Res> {
  factory _$$NearbyTourPointDtoImplCopyWith(
    _$NearbyTourPointDtoImpl value,
    $Res Function(_$NearbyTourPointDtoImpl) then,
  ) = __$$NearbyTourPointDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String cityName,
    String tourTypeName,
    String title,
    String mainImage,
    double distance,
  });
}

/// @nodoc
class __$$NearbyTourPointDtoImplCopyWithImpl<$Res>
    extends _$NearbyTourPointDtoCopyWithImpl<$Res, _$NearbyTourPointDtoImpl>
    implements _$$NearbyTourPointDtoImplCopyWith<$Res> {
  __$$NearbyTourPointDtoImplCopyWithImpl(
    _$NearbyTourPointDtoImpl _value,
    $Res Function(_$NearbyTourPointDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NearbyTourPointDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cityName = null,
    Object? tourTypeName = null,
    Object? title = null,
    Object? mainImage = null,
    Object? distance = null,
  }) {
    return _then(
      _$NearbyTourPointDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cityName: null == cityName
            ? _value.cityName
            : cityName // ignore: cast_nullable_to_non_nullable
                  as String,
        tourTypeName: null == tourTypeName
            ? _value.tourTypeName
            : tourTypeName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        mainImage: null == mainImage
            ? _value.mainImage
            : mainImage // ignore: cast_nullable_to_non_nullable
                  as String,
        distance: null == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyTourPointDtoImpl implements _NearbyTourPointDto {
  const _$NearbyTourPointDtoImpl({
    required this.id,
    required this.cityName,
    required this.tourTypeName,
    required this.title,
    required this.mainImage,
    required this.distance,
  });

  factory _$NearbyTourPointDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyTourPointDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String cityName;
  @override
  final String tourTypeName;
  @override
  final String title;
  @override
  final String mainImage;
  @override
  final double distance;

  @override
  String toString() {
    return 'NearbyTourPointDto(id: $id, cityName: $cityName, tourTypeName: $tourTypeName, title: $title, mainImage: $mainImage, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyTourPointDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.tourTypeName, tourTypeName) ||
                other.tourTypeName == tourTypeName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mainImage, mainImage) ||
                other.mainImage == mainImage) &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cityName,
    tourTypeName,
    title,
    mainImage,
    distance,
  );

  /// Create a copy of NearbyTourPointDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyTourPointDtoImplCopyWith<_$NearbyTourPointDtoImpl> get copyWith =>
      __$$NearbyTourPointDtoImplCopyWithImpl<_$NearbyTourPointDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyTourPointDtoImplToJson(this);
  }
}

abstract class _NearbyTourPointDto implements NearbyTourPointDto {
  const factory _NearbyTourPointDto({
    required final String id,
    required final String cityName,
    required final String tourTypeName,
    required final String title,
    required final String mainImage,
    required final double distance,
  }) = _$NearbyTourPointDtoImpl;

  factory _NearbyTourPointDto.fromJson(Map<String, dynamic> json) =
      _$NearbyTourPointDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get cityName;
  @override
  String get tourTypeName;
  @override
  String get title;
  @override
  String get mainImage;
  @override
  double get distance;

  /// Create a copy of NearbyTourPointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbyTourPointDtoImplCopyWith<_$NearbyTourPointDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
