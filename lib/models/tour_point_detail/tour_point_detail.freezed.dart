// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_point_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourPointDetail _$TourPointDetailFromJson(Map<String, dynamic> json) {
  return _TourPointDetail.fromJson(json);
}

/// @nodoc
mixin _$TourPointDetail {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get mainImage => throw _privateConstructorUsedError;
  List<String> get otherImages => throw _privateConstructorUsedError;
  String get cityName => throw _privateConstructorUsedError;
  String get districtName => throw _privateConstructorUsedError;
  String get regionName => throw _privateConstructorUsedError;
  String get countryName => throw _privateConstructorUsedError;
  String get tourTypeName => throw _privateConstructorUsedError;
  String get tourDifficultyName => throw _privateConstructorUsedError;
  List<CityDto> get cities => throw _privateConstructorUsedError;
  List<DistrictDto> get districts => throw _privateConstructorUsedError;
  bool get isFavorites => throw _privateConstructorUsedError;

  /// Serializes this TourPointDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourPointDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourPointDetailCopyWith<TourPointDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourPointDetailCopyWith<$Res> {
  factory $TourPointDetailCopyWith(
    TourPointDetail value,
    $Res Function(TourPointDetail) then,
  ) = _$TourPointDetailCopyWithImpl<$Res, TourPointDetail>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String mainImage,
    List<String> otherImages,
    String cityName,
    String districtName,
    String regionName,
    String countryName,
    String tourTypeName,
    String tourDifficultyName,
    List<CityDto> cities,
    List<DistrictDto> districts,
    bool isFavorites,
  });
}

/// @nodoc
class _$TourPointDetailCopyWithImpl<$Res, $Val extends TourPointDetail>
    implements $TourPointDetailCopyWith<$Res> {
  _$TourPointDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourPointDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? mainImage = null,
    Object? otherImages = null,
    Object? cityName = null,
    Object? districtName = null,
    Object? regionName = null,
    Object? countryName = null,
    Object? tourTypeName = null,
    Object? tourDifficultyName = null,
    Object? cities = null,
    Object? districts = null,
    Object? isFavorites = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            mainImage: null == mainImage
                ? _value.mainImage
                : mainImage // ignore: cast_nullable_to_non_nullable
                      as String,
            otherImages: null == otherImages
                ? _value.otherImages
                : otherImages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            cityName: null == cityName
                ? _value.cityName
                : cityName // ignore: cast_nullable_to_non_nullable
                      as String,
            districtName: null == districtName
                ? _value.districtName
                : districtName // ignore: cast_nullable_to_non_nullable
                      as String,
            regionName: null == regionName
                ? _value.regionName
                : regionName // ignore: cast_nullable_to_non_nullable
                      as String,
            countryName: null == countryName
                ? _value.countryName
                : countryName // ignore: cast_nullable_to_non_nullable
                      as String,
            tourTypeName: null == tourTypeName
                ? _value.tourTypeName
                : tourTypeName // ignore: cast_nullable_to_non_nullable
                      as String,
            tourDifficultyName: null == tourDifficultyName
                ? _value.tourDifficultyName
                : tourDifficultyName // ignore: cast_nullable_to_non_nullable
                      as String,
            cities: null == cities
                ? _value.cities
                : cities // ignore: cast_nullable_to_non_nullable
                      as List<CityDto>,
            districts: null == districts
                ? _value.districts
                : districts // ignore: cast_nullable_to_non_nullable
                      as List<DistrictDto>,
            isFavorites: null == isFavorites
                ? _value.isFavorites
                : isFavorites // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourPointDetailImplCopyWith<$Res>
    implements $TourPointDetailCopyWith<$Res> {
  factory _$$TourPointDetailImplCopyWith(
    _$TourPointDetailImpl value,
    $Res Function(_$TourPointDetailImpl) then,
  ) = __$$TourPointDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String mainImage,
    List<String> otherImages,
    String cityName,
    String districtName,
    String regionName,
    String countryName,
    String tourTypeName,
    String tourDifficultyName,
    List<CityDto> cities,
    List<DistrictDto> districts,
    bool isFavorites,
  });
}

/// @nodoc
class __$$TourPointDetailImplCopyWithImpl<$Res>
    extends _$TourPointDetailCopyWithImpl<$Res, _$TourPointDetailImpl>
    implements _$$TourPointDetailImplCopyWith<$Res> {
  __$$TourPointDetailImplCopyWithImpl(
    _$TourPointDetailImpl _value,
    $Res Function(_$TourPointDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourPointDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? mainImage = null,
    Object? otherImages = null,
    Object? cityName = null,
    Object? districtName = null,
    Object? regionName = null,
    Object? countryName = null,
    Object? tourTypeName = null,
    Object? tourDifficultyName = null,
    Object? cities = null,
    Object? districts = null,
    Object? isFavorites = null,
  }) {
    return _then(
      _$TourPointDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        mainImage: null == mainImage
            ? _value.mainImage
            : mainImage // ignore: cast_nullable_to_non_nullable
                  as String,
        otherImages: null == otherImages
            ? _value._otherImages
            : otherImages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        cityName: null == cityName
            ? _value.cityName
            : cityName // ignore: cast_nullable_to_non_nullable
                  as String,
        districtName: null == districtName
            ? _value.districtName
            : districtName // ignore: cast_nullable_to_non_nullable
                  as String,
        regionName: null == regionName
            ? _value.regionName
            : regionName // ignore: cast_nullable_to_non_nullable
                  as String,
        countryName: null == countryName
            ? _value.countryName
            : countryName // ignore: cast_nullable_to_non_nullable
                  as String,
        tourTypeName: null == tourTypeName
            ? _value.tourTypeName
            : tourTypeName // ignore: cast_nullable_to_non_nullable
                  as String,
        tourDifficultyName: null == tourDifficultyName
            ? _value.tourDifficultyName
            : tourDifficultyName // ignore: cast_nullable_to_non_nullable
                  as String,
        cities: null == cities
            ? _value._cities
            : cities // ignore: cast_nullable_to_non_nullable
                  as List<CityDto>,
        districts: null == districts
            ? _value._districts
            : districts // ignore: cast_nullable_to_non_nullable
                  as List<DistrictDto>,
        isFavorites: null == isFavorites
            ? _value.isFavorites
            : isFavorites // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourPointDetailImpl implements _TourPointDetail {
  const _$TourPointDetailImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.mainImage,
    required final List<String> otherImages,
    required this.cityName,
    required this.districtName,
    required this.regionName,
    required this.countryName,
    required this.tourTypeName,
    required this.tourDifficultyName,
    required final List<CityDto> cities,
    required final List<DistrictDto> districts,
    required this.isFavorites,
  }) : _otherImages = otherImages,
       _cities = cities,
       _districts = districts;

  factory _$TourPointDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourPointDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String mainImage;
  final List<String> _otherImages;
  @override
  List<String> get otherImages {
    if (_otherImages is EqualUnmodifiableListView) return _otherImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_otherImages);
  }

  @override
  final String cityName;
  @override
  final String districtName;
  @override
  final String regionName;
  @override
  final String countryName;
  @override
  final String tourTypeName;
  @override
  final String tourDifficultyName;
  final List<CityDto> _cities;
  @override
  List<CityDto> get cities {
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cities);
  }

  final List<DistrictDto> _districts;
  @override
  List<DistrictDto> get districts {
    if (_districts is EqualUnmodifiableListView) return _districts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_districts);
  }

  @override
  final bool isFavorites;

  @override
  String toString() {
    return 'TourPointDetail(id: $id, title: $title, description: $description, mainImage: $mainImage, otherImages: $otherImages, cityName: $cityName, districtName: $districtName, regionName: $regionName, countryName: $countryName, tourTypeName: $tourTypeName, tourDifficultyName: $tourDifficultyName, cities: $cities, districts: $districts, isFavorites: $isFavorites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourPointDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mainImage, mainImage) ||
                other.mainImage == mainImage) &&
            const DeepCollectionEquality().equals(
              other._otherImages,
              _otherImages,
            ) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.districtName, districtName) ||
                other.districtName == districtName) &&
            (identical(other.regionName, regionName) ||
                other.regionName == regionName) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.tourTypeName, tourTypeName) ||
                other.tourTypeName == tourTypeName) &&
            (identical(other.tourDifficultyName, tourDifficultyName) ||
                other.tourDifficultyName == tourDifficultyName) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            const DeepCollectionEquality().equals(
              other._districts,
              _districts,
            ) &&
            (identical(other.isFavorites, isFavorites) ||
                other.isFavorites == isFavorites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    mainImage,
    const DeepCollectionEquality().hash(_otherImages),
    cityName,
    districtName,
    regionName,
    countryName,
    tourTypeName,
    tourDifficultyName,
    const DeepCollectionEquality().hash(_cities),
    const DeepCollectionEquality().hash(_districts),
    isFavorites,
  );

  /// Create a copy of TourPointDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourPointDetailImplCopyWith<_$TourPointDetailImpl> get copyWith =>
      __$$TourPointDetailImplCopyWithImpl<_$TourPointDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourPointDetailImplToJson(this);
  }
}

abstract class _TourPointDetail implements TourPointDetail {
  const factory _TourPointDetail({
    required final String id,
    required final String title,
    required final String description,
    required final String mainImage,
    required final List<String> otherImages,
    required final String cityName,
    required final String districtName,
    required final String regionName,
    required final String countryName,
    required final String tourTypeName,
    required final String tourDifficultyName,
    required final List<CityDto> cities,
    required final List<DistrictDto> districts,
    required final bool isFavorites,
  }) = _$TourPointDetailImpl;

  factory _TourPointDetail.fromJson(Map<String, dynamic> json) =
      _$TourPointDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get mainImage;
  @override
  List<String> get otherImages;
  @override
  String get cityName;
  @override
  String get districtName;
  @override
  String get regionName;
  @override
  String get countryName;
  @override
  String get tourTypeName;
  @override
  String get tourDifficultyName;
  @override
  List<CityDto> get cities;
  @override
  List<DistrictDto> get districts;
  @override
  bool get isFavorites;

  /// Create a copy of TourPointDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourPointDetailImplCopyWith<_$TourPointDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
