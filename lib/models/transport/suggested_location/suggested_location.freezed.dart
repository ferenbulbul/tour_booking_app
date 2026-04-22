// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggested_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SuggestedLocationTranslation _$SuggestedLocationTranslationFromJson(
  Map<String, dynamic> json,
) {
  return _SuggestedLocationTranslation.fromJson(json);
}

/// @nodoc
mixin _$SuggestedLocationTranslation {
  String? get languageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this SuggestedLocationTranslation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestedLocationTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestedLocationTranslationCopyWith<SuggestedLocationTranslation>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedLocationTranslationCopyWith<$Res> {
  factory $SuggestedLocationTranslationCopyWith(
    SuggestedLocationTranslation value,
    $Res Function(SuggestedLocationTranslation) then,
  ) =
      _$SuggestedLocationTranslationCopyWithImpl<
        $Res,
        SuggestedLocationTranslation
      >;
  @useResult
  $Res call({String? languageCode, String name, String? description});
}

/// @nodoc
class _$SuggestedLocationTranslationCopyWithImpl<
  $Res,
  $Val extends SuggestedLocationTranslation
>
    implements $SuggestedLocationTranslationCopyWith<$Res> {
  _$SuggestedLocationTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestedLocationTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = freezed,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            languageCode: freezed == languageCode
                ? _value.languageCode
                : languageCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuggestedLocationTranslationImplCopyWith<$Res>
    implements $SuggestedLocationTranslationCopyWith<$Res> {
  factory _$$SuggestedLocationTranslationImplCopyWith(
    _$SuggestedLocationTranslationImpl value,
    $Res Function(_$SuggestedLocationTranslationImpl) then,
  ) = __$$SuggestedLocationTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? languageCode, String name, String? description});
}

/// @nodoc
class __$$SuggestedLocationTranslationImplCopyWithImpl<$Res>
    extends
        _$SuggestedLocationTranslationCopyWithImpl<
          $Res,
          _$SuggestedLocationTranslationImpl
        >
    implements _$$SuggestedLocationTranslationImplCopyWith<$Res> {
  __$$SuggestedLocationTranslationImplCopyWithImpl(
    _$SuggestedLocationTranslationImpl _value,
    $Res Function(_$SuggestedLocationTranslationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuggestedLocationTranslation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = freezed,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _$SuggestedLocationTranslationImpl(
        languageCode: freezed == languageCode
            ? _value.languageCode
            : languageCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedLocationTranslationImpl
    implements _SuggestedLocationTranslation {
  const _$SuggestedLocationTranslationImpl({
    this.languageCode,
    this.name = '',
    this.description,
  });

  factory _$SuggestedLocationTranslationImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SuggestedLocationTranslationImplFromJson(json);

  @override
  final String? languageCode;
  @override
  @JsonKey()
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'SuggestedLocationTranslation(languageCode: $languageCode, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedLocationTranslationImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode, name, description);

  /// Create a copy of SuggestedLocationTranslation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedLocationTranslationImplCopyWith<
    _$SuggestedLocationTranslationImpl
  >
  get copyWith =>
      __$$SuggestedLocationTranslationImplCopyWithImpl<
        _$SuggestedLocationTranslationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedLocationTranslationImplToJson(this);
  }
}

abstract class _SuggestedLocationTranslation
    implements SuggestedLocationTranslation {
  const factory _SuggestedLocationTranslation({
    final String? languageCode,
    final String name,
    final String? description,
  }) = _$SuggestedLocationTranslationImpl;

  factory _SuggestedLocationTranslation.fromJson(Map<String, dynamic> json) =
      _$SuggestedLocationTranslationImpl.fromJson;

  @override
  String? get languageCode;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of SuggestedLocationTranslation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestedLocationTranslationImplCopyWith<
    _$SuggestedLocationTranslationImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TransportSuggestedLocation _$TransportSuggestedLocationFromJson(
  Map<String, dynamic> json,
) {
  return _TransportSuggestedLocation.fromJson(json);
}

/// @nodoc
mixin _$TransportSuggestedLocation {
  String get id => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;
  String? get districtId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<SuggestedLocationTranslation> get translations =>
      throw _privateConstructorUsedError;

  /// Serializes this TransportSuggestedLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportSuggestedLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportSuggestedLocationCopyWith<TransportSuggestedLocation>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportSuggestedLocationCopyWith<$Res> {
  factory $TransportSuggestedLocationCopyWith(
    TransportSuggestedLocation value,
    $Res Function(TransportSuggestedLocation) then,
  ) =
      _$TransportSuggestedLocationCopyWithImpl<
        $Res,
        TransportSuggestedLocation
      >;
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String cityId,
    String? districtId,
    bool isActive,
    List<SuggestedLocationTranslation> translations,
  });
}

/// @nodoc
class _$TransportSuggestedLocationCopyWithImpl<
  $Res,
  $Val extends TransportSuggestedLocation
>
    implements $TransportSuggestedLocationCopyWith<$Res> {
  _$TransportSuggestedLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportSuggestedLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? cityId = null,
    Object? districtId = freezed,
    Object? isActive = null,
    Object? translations = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            districtId: freezed == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            translations: null == translations
                ? _value.translations
                : translations // ignore: cast_nullable_to_non_nullable
                      as List<SuggestedLocationTranslation>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportSuggestedLocationImplCopyWith<$Res>
    implements $TransportSuggestedLocationCopyWith<$Res> {
  factory _$$TransportSuggestedLocationImplCopyWith(
    _$TransportSuggestedLocationImpl value,
    $Res Function(_$TransportSuggestedLocationImpl) then,
  ) = __$$TransportSuggestedLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double latitude,
    double longitude,
    String cityId,
    String? districtId,
    bool isActive,
    List<SuggestedLocationTranslation> translations,
  });
}

/// @nodoc
class __$$TransportSuggestedLocationImplCopyWithImpl<$Res>
    extends
        _$TransportSuggestedLocationCopyWithImpl<
          $Res,
          _$TransportSuggestedLocationImpl
        >
    implements _$$TransportSuggestedLocationImplCopyWith<$Res> {
  __$$TransportSuggestedLocationImplCopyWithImpl(
    _$TransportSuggestedLocationImpl _value,
    $Res Function(_$TransportSuggestedLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportSuggestedLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? cityId = null,
    Object? districtId = freezed,
    Object? isActive = null,
    Object? translations = null,
  }) {
    return _then(
      _$TransportSuggestedLocationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        districtId: freezed == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        translations: null == translations
            ? _value._translations
            : translations // ignore: cast_nullable_to_non_nullable
                  as List<SuggestedLocationTranslation>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportSuggestedLocationImpl extends _TransportSuggestedLocation {
  const _$TransportSuggestedLocationImpl({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    this.districtId,
    this.isActive = true,
    final List<SuggestedLocationTranslation> translations = const [],
  }) : _translations = translations,
       super._();

  factory _$TransportSuggestedLocationImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TransportSuggestedLocationImplFromJson(json);

  @override
  final String id;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String cityId;
  @override
  final String? districtId;
  @override
  @JsonKey()
  final bool isActive;
  final List<SuggestedLocationTranslation> _translations;
  @override
  @JsonKey()
  List<SuggestedLocationTranslation> get translations {
    if (_translations is EqualUnmodifiableListView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translations);
  }

  @override
  String toString() {
    return 'TransportSuggestedLocation(id: $id, latitude: $latitude, longitude: $longitude, cityId: $cityId, districtId: $districtId, isActive: $isActive, translations: $translations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportSuggestedLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._translations,
              _translations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    latitude,
    longitude,
    cityId,
    districtId,
    isActive,
    const DeepCollectionEquality().hash(_translations),
  );

  /// Create a copy of TransportSuggestedLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportSuggestedLocationImplCopyWith<_$TransportSuggestedLocationImpl>
  get copyWith =>
      __$$TransportSuggestedLocationImplCopyWithImpl<
        _$TransportSuggestedLocationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportSuggestedLocationImplToJson(this);
  }
}

abstract class _TransportSuggestedLocation extends TransportSuggestedLocation {
  const factory _TransportSuggestedLocation({
    required final String id,
    required final double latitude,
    required final double longitude,
    required final String cityId,
    final String? districtId,
    final bool isActive,
    final List<SuggestedLocationTranslation> translations,
  }) = _$TransportSuggestedLocationImpl;
  const _TransportSuggestedLocation._() : super._();

  factory _TransportSuggestedLocation.fromJson(Map<String, dynamic> json) =
      _$TransportSuggestedLocationImpl.fromJson;

  @override
  String get id;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get cityId;
  @override
  String? get districtId;
  @override
  bool get isActive;
  @override
  List<SuggestedLocationTranslation> get translations;

  /// Create a copy of TransportSuggestedLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportSuggestedLocationImplCopyWith<_$TransportSuggestedLocationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
