// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_search_detailed_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourSearchRequest _$TourSearchRequestFromJson(Map<String, dynamic> json) {
  return _TourSearchRequest.fromJson(json);
}

/// @nodoc
mixin _$TourSearchRequest {
  int get type => throw _privateConstructorUsedError;
  String? get regionId => throw _privateConstructorUsedError;
  String? get cityId => throw _privateConstructorUsedError;
  String? get districtId => throw _privateConstructorUsedError;

  /// Serializes this TourSearchRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourSearchRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourSearchRequestCopyWith<TourSearchRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourSearchRequestCopyWith<$Res> {
  factory $TourSearchRequestCopyWith(
    TourSearchRequest value,
    $Res Function(TourSearchRequest) then,
  ) = _$TourSearchRequestCopyWithImpl<$Res, TourSearchRequest>;
  @useResult
  $Res call({int type, String? regionId, String? cityId, String? districtId});
}

/// @nodoc
class _$TourSearchRequestCopyWithImpl<$Res, $Val extends TourSearchRequest>
    implements $TourSearchRequestCopyWith<$Res> {
  _$TourSearchRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourSearchRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? districtId = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int,
            regionId: freezed == regionId
                ? _value.regionId
                : regionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cityId: freezed == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String?,
            districtId: freezed == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourSearchRequestImplCopyWith<$Res>
    implements $TourSearchRequestCopyWith<$Res> {
  factory _$$TourSearchRequestImplCopyWith(
    _$TourSearchRequestImpl value,
    $Res Function(_$TourSearchRequestImpl) then,
  ) = __$$TourSearchRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int type, String? regionId, String? cityId, String? districtId});
}

/// @nodoc
class __$$TourSearchRequestImplCopyWithImpl<$Res>
    extends _$TourSearchRequestCopyWithImpl<$Res, _$TourSearchRequestImpl>
    implements _$$TourSearchRequestImplCopyWith<$Res> {
  __$$TourSearchRequestImplCopyWithImpl(
    _$TourSearchRequestImpl _value,
    $Res Function(_$TourSearchRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourSearchRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? regionId = freezed,
    Object? cityId = freezed,
    Object? districtId = freezed,
  }) {
    return _then(
      _$TourSearchRequestImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int,
        regionId: freezed == regionId
            ? _value.regionId
            : regionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cityId: freezed == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        districtId: freezed == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourSearchRequestImpl implements _TourSearchRequest {
  const _$TourSearchRequestImpl({
    required this.type,
    this.regionId,
    this.cityId,
    this.districtId,
  });

  factory _$TourSearchRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourSearchRequestImplFromJson(json);

  @override
  final int type;
  @override
  final String? regionId;
  @override
  final String? cityId;
  @override
  final String? districtId;

  @override
  String toString() {
    return 'TourSearchRequest(type: $type, regionId: $regionId, cityId: $cityId, districtId: $districtId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourSearchRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, regionId, cityId, districtId);

  /// Create a copy of TourSearchRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourSearchRequestImplCopyWith<_$TourSearchRequestImpl> get copyWith =>
      __$$TourSearchRequestImplCopyWithImpl<_$TourSearchRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourSearchRequestImplToJson(this);
  }
}

abstract class _TourSearchRequest implements TourSearchRequest {
  const factory _TourSearchRequest({
    required final int type,
    final String? regionId,
    final String? cityId,
    final String? districtId,
  }) = _$TourSearchRequestImpl;

  factory _TourSearchRequest.fromJson(Map<String, dynamic> json) =
      _$TourSearchRequestImpl.fromJson;

  @override
  int get type;
  @override
  String? get regionId;
  @override
  String? get cityId;
  @override
  String? get districtId;

  /// Create a copy of TourSearchRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourSearchRequestImplCopyWith<_$TourSearchRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
