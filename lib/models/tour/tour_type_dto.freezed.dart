// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_type_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourTypeDto _$TourTypeDtoFromJson(Map<String, dynamic> json) {
  return _TourTypeDto.fromJson(json);
}

/// @nodoc
mixin _$TourTypeDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'mainImageUrl')
  String get mainImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbImageUrl')
  String get thumbImageUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this TourTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourTypeDtoCopyWith<TourTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourTypeDtoCopyWith<$Res> {
  factory $TourTypeDtoCopyWith(
    TourTypeDto value,
    $Res Function(TourTypeDto) then,
  ) = _$TourTypeDtoCopyWithImpl<$Res, TourTypeDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'mainImageUrl') String mainImageUrl,
    @JsonKey(name: 'thumbImageUrl') String thumbImageUrl,
    String title,
    String description,
  });
}

/// @nodoc
class _$TourTypeDtoCopyWithImpl<$Res, $Val extends TourTypeDto>
    implements $TourTypeDtoCopyWith<$Res> {
  _$TourTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mainImageUrl = null,
    Object? thumbImageUrl = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            mainImageUrl: null == mainImageUrl
                ? _value.mainImageUrl
                : mainImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbImageUrl: null == thumbImageUrl
                ? _value.thumbImageUrl
                : thumbImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourTypeDtoImplCopyWith<$Res>
    implements $TourTypeDtoCopyWith<$Res> {
  factory _$$TourTypeDtoImplCopyWith(
    _$TourTypeDtoImpl value,
    $Res Function(_$TourTypeDtoImpl) then,
  ) = __$$TourTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'mainImageUrl') String mainImageUrl,
    @JsonKey(name: 'thumbImageUrl') String thumbImageUrl,
    String title,
    String description,
  });
}

/// @nodoc
class __$$TourTypeDtoImplCopyWithImpl<$Res>
    extends _$TourTypeDtoCopyWithImpl<$Res, _$TourTypeDtoImpl>
    implements _$$TourTypeDtoImplCopyWith<$Res> {
  __$$TourTypeDtoImplCopyWithImpl(
    _$TourTypeDtoImpl _value,
    $Res Function(_$TourTypeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mainImageUrl = null,
    Object? thumbImageUrl = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(
      _$TourTypeDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        mainImageUrl: null == mainImageUrl
            ? _value.mainImageUrl
            : mainImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbImageUrl: null == thumbImageUrl
            ? _value.thumbImageUrl
            : thumbImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourTypeDtoImpl implements _TourTypeDto {
  const _$TourTypeDtoImpl({
    required this.id,
    @JsonKey(name: 'mainImageUrl') required this.mainImageUrl,
    @JsonKey(name: 'thumbImageUrl') required this.thumbImageUrl,
    required this.title,
    required this.description,
  });

  factory _$TourTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourTypeDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'mainImageUrl')
  final String mainImageUrl;
  @override
  @JsonKey(name: 'thumbImageUrl')
  final String thumbImageUrl;
  @override
  final String title;
  @override
  final String description;

  @override
  String toString() {
    return 'TourTypeDto(id: $id, mainImageUrl: $mainImageUrl, thumbImageUrl: $thumbImageUrl, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.thumbImageUrl, thumbImageUrl) ||
                other.thumbImageUrl == thumbImageUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    mainImageUrl,
    thumbImageUrl,
    title,
    description,
  );

  /// Create a copy of TourTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourTypeDtoImplCopyWith<_$TourTypeDtoImpl> get copyWith =>
      __$$TourTypeDtoImplCopyWithImpl<_$TourTypeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TourTypeDtoImplToJson(this);
  }
}

abstract class _TourTypeDto implements TourTypeDto {
  const factory _TourTypeDto({
    required final String id,
    @JsonKey(name: 'mainImageUrl') required final String mainImageUrl,
    @JsonKey(name: 'thumbImageUrl') required final String thumbImageUrl,
    required final String title,
    required final String description,
  }) = _$TourTypeDtoImpl;

  factory _TourTypeDto.fromJson(Map<String, dynamic> json) =
      _$TourTypeDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'mainImageUrl')
  String get mainImageUrl;
  @override
  @JsonKey(name: 'thumbImageUrl')
  String get thumbImageUrl;
  @override
  String get title;
  @override
  String get description;

  /// Create a copy of TourTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourTypeDtoImplCopyWith<_$TourTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
