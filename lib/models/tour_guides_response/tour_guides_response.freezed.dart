// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_guides_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourGuidesResponse _$TourGuidesResponseFromJson(Map<String, dynamic> json) {
  return _TourGuidesResponse.fromJson(json);
}

/// @nodoc
mixin _$TourGuidesResponse {
  List<Guide> get guides => throw _privateConstructorUsedError;

  /// Serializes this TourGuidesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourGuidesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourGuidesResponseCopyWith<TourGuidesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourGuidesResponseCopyWith<$Res> {
  factory $TourGuidesResponseCopyWith(
    TourGuidesResponse value,
    $Res Function(TourGuidesResponse) then,
  ) = _$TourGuidesResponseCopyWithImpl<$Res, TourGuidesResponse>;
  @useResult
  $Res call({List<Guide> guides});
}

/// @nodoc
class _$TourGuidesResponseCopyWithImpl<$Res, $Val extends TourGuidesResponse>
    implements $TourGuidesResponseCopyWith<$Res> {
  _$TourGuidesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourGuidesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? guides = null}) {
    return _then(
      _value.copyWith(
            guides: null == guides
                ? _value.guides
                : guides // ignore: cast_nullable_to_non_nullable
                      as List<Guide>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourGuidesResponseImplCopyWith<$Res>
    implements $TourGuidesResponseCopyWith<$Res> {
  factory _$$TourGuidesResponseImplCopyWith(
    _$TourGuidesResponseImpl value,
    $Res Function(_$TourGuidesResponseImpl) then,
  ) = __$$TourGuidesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Guide> guides});
}

/// @nodoc
class __$$TourGuidesResponseImplCopyWithImpl<$Res>
    extends _$TourGuidesResponseCopyWithImpl<$Res, _$TourGuidesResponseImpl>
    implements _$$TourGuidesResponseImplCopyWith<$Res> {
  __$$TourGuidesResponseImplCopyWithImpl(
    _$TourGuidesResponseImpl _value,
    $Res Function(_$TourGuidesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourGuidesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? guides = null}) {
    return _then(
      _$TourGuidesResponseImpl(
        guides: null == guides
            ? _value._guides
            : guides // ignore: cast_nullable_to_non_nullable
                  as List<Guide>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourGuidesResponseImpl implements _TourGuidesResponse {
  const _$TourGuidesResponseImpl({final List<Guide> guides = const <Guide>[]})
    : _guides = guides;

  factory _$TourGuidesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourGuidesResponseImplFromJson(json);

  final List<Guide> _guides;
  @override
  @JsonKey()
  List<Guide> get guides {
    if (_guides is EqualUnmodifiableListView) return _guides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guides);
  }

  @override
  String toString() {
    return 'TourGuidesResponse(guides: $guides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourGuidesResponseImpl &&
            const DeepCollectionEquality().equals(other._guides, _guides));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_guides));

  /// Create a copy of TourGuidesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourGuidesResponseImplCopyWith<_$TourGuidesResponseImpl> get copyWith =>
      __$$TourGuidesResponseImplCopyWithImpl<_$TourGuidesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourGuidesResponseImplToJson(this);
  }
}

abstract class _TourGuidesResponse implements TourGuidesResponse {
  const factory _TourGuidesResponse({final List<Guide> guides}) =
      _$TourGuidesResponseImpl;

  factory _TourGuidesResponse.fromJson(Map<String, dynamic> json) =
      _$TourGuidesResponseImpl.fromJson;

  @override
  List<Guide> get guides;

  /// Create a copy of TourGuidesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourGuidesResponseImplCopyWith<_$TourGuidesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
