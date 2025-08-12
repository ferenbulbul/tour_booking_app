// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Guide _$GuideFromJson(Map<String, dynamic> json) {
  return _Guide.fromJson(json);
}

/// @nodoc
mixin _$Guide {
  String get guideId => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  List<String> get languages =>
      throw _privateConstructorUsedError; // backend null dönerse map'lerken boş listeye düşebiliriz
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  /// Serializes this Guide to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Guide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuideCopyWith<Guide> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideCopyWith<$Res> {
  factory $GuideCopyWith(Guide value, $Res Function(Guide) then) =
      _$GuideCopyWithImpl<$Res, Guide>;
  @useResult
  $Res call({
    String guideId,
    num price,
    List<String> languages,
    String firstName,
    String lastName,
    String? image,
  });
}

/// @nodoc
class _$GuideCopyWithImpl<$Res, $Val extends Guide>
    implements $GuideCopyWith<$Res> {
  _$GuideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Guide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guideId = null,
    Object? price = null,
    Object? languages = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? image = freezed,
  }) {
    return _then(
      _value.copyWith(
            guideId: null == guideId
                ? _value.guideId
                : guideId // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as num,
            languages: null == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuideImplCopyWith<$Res> implements $GuideCopyWith<$Res> {
  factory _$$GuideImplCopyWith(
    _$GuideImpl value,
    $Res Function(_$GuideImpl) then,
  ) = __$$GuideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String guideId,
    num price,
    List<String> languages,
    String firstName,
    String lastName,
    String? image,
  });
}

/// @nodoc
class __$$GuideImplCopyWithImpl<$Res>
    extends _$GuideCopyWithImpl<$Res, _$GuideImpl>
    implements _$$GuideImplCopyWith<$Res> {
  __$$GuideImplCopyWithImpl(
    _$GuideImpl _value,
    $Res Function(_$GuideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Guide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guideId = null,
    Object? price = null,
    Object? languages = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? image = freezed,
  }) {
    return _then(
      _$GuideImpl(
        guideId: null == guideId
            ? _value.guideId
            : guideId // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as num,
        languages: null == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GuideImpl implements _Guide {
  const _$GuideImpl({
    required this.guideId,
    required this.price,
    final List<String> languages = const <String>[],
    required this.firstName,
    required this.lastName,
    this.image,
  }) : _languages = languages;

  factory _$GuideImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuideImplFromJson(json);

  @override
  final String guideId;
  @override
  final num price;
  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  // backend null dönerse map'lerken boş listeye düşebiliriz
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? image;

  @override
  String toString() {
    return 'Guide(guideId: $guideId, price: $price, languages: $languages, firstName: $firstName, lastName: $lastName, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideImpl &&
            (identical(other.guideId, guideId) || other.guideId == guideId) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    guideId,
    price,
    const DeepCollectionEquality().hash(_languages),
    firstName,
    lastName,
    image,
  );

  /// Create a copy of Guide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideImplCopyWith<_$GuideImpl> get copyWith =>
      __$$GuideImplCopyWithImpl<_$GuideImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuideImplToJson(this);
  }
}

abstract class _Guide implements Guide {
  const factory _Guide({
    required final String guideId,
    required final num price,
    final List<String> languages,
    required final String firstName,
    required final String lastName,
    final String? image,
  }) = _$GuideImpl;

  factory _Guide.fromJson(Map<String, dynamic> json) = _$GuideImpl.fromJson;

  @override
  String get guideId;
  @override
  num get price;
  @override
  List<String> get languages; // backend null dönerse map'lerken boş listeye düşebiliriz
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get image;

  /// Create a copy of Guide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideImplCopyWith<_$GuideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
