// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_guide_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourGuideRequest _$TourGuideRequestFromJson(Map<String, dynamic> json) {
  return _TourGuideRequest.fromJson(json);
}

/// @nodoc
mixin _$TourGuideRequest {
  String get cityId => throw _privateConstructorUsedError;
  String get districtId => throw _privateConstructorUsedError;
  String get tourPointId => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateToString)
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this TourGuideRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourGuideRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourGuideRequestCopyWith<TourGuideRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourGuideRequestCopyWith<$Res> {
  factory $TourGuideRequestCopyWith(
    TourGuideRequest value,
    $Res Function(TourGuideRequest) then,
  ) = _$TourGuideRequestCopyWithImpl<$Res, TourGuideRequest>;
  @useResult
  $Res call({
    String cityId,
    String districtId,
    String tourPointId,
    @JsonKey(toJson: _dateToString) DateTime date,
  });
}

/// @nodoc
class _$TourGuideRequestCopyWithImpl<$Res, $Val extends TourGuideRequest>
    implements $TourGuideRequestCopyWith<$Res> {
  _$TourGuideRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourGuideRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityId = null,
    Object? districtId = null,
    Object? tourPointId = null,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            districtId: null == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointId: null == tourPointId
                ? _value.tourPointId
                : tourPointId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TourGuideRequestImplCopyWith<$Res>
    implements $TourGuideRequestCopyWith<$Res> {
  factory _$$TourGuideRequestImplCopyWith(
    _$TourGuideRequestImpl value,
    $Res Function(_$TourGuideRequestImpl) then,
  ) = __$$TourGuideRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cityId,
    String districtId,
    String tourPointId,
    @JsonKey(toJson: _dateToString) DateTime date,
  });
}

/// @nodoc
class __$$TourGuideRequestImplCopyWithImpl<$Res>
    extends _$TourGuideRequestCopyWithImpl<$Res, _$TourGuideRequestImpl>
    implements _$$TourGuideRequestImplCopyWith<$Res> {
  __$$TourGuideRequestImplCopyWithImpl(
    _$TourGuideRequestImpl _value,
    $Res Function(_$TourGuideRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourGuideRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityId = null,
    Object? districtId = null,
    Object? tourPointId = null,
    Object? date = null,
  }) {
    return _then(
      _$TourGuideRequestImpl(
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        districtId: null == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointId: null == tourPointId
            ? _value.tourPointId
            : tourPointId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourGuideRequestImpl implements _TourGuideRequest {
  const _$TourGuideRequestImpl({
    required this.cityId,
    required this.districtId,
    required this.tourPointId,
    @JsonKey(toJson: _dateToString) required this.date,
  });

  factory _$TourGuideRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourGuideRequestImplFromJson(json);

  @override
  final String cityId;
  @override
  final String districtId;
  @override
  final String tourPointId;
  @override
  @JsonKey(toJson: _dateToString)
  final DateTime date;

  @override
  String toString() {
    return 'TourGuideRequest(cityId: $cityId, districtId: $districtId, tourPointId: $tourPointId, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourGuideRequestImpl &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.tourPointId, tourPointId) ||
                other.tourPointId == tourPointId) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cityId, districtId, tourPointId, date);

  /// Create a copy of TourGuideRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourGuideRequestImplCopyWith<_$TourGuideRequestImpl> get copyWith =>
      __$$TourGuideRequestImplCopyWithImpl<_$TourGuideRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourGuideRequestImplToJson(this);
  }
}

abstract class _TourGuideRequest implements TourGuideRequest {
  const factory _TourGuideRequest({
    required final String cityId,
    required final String districtId,
    required final String tourPointId,
    @JsonKey(toJson: _dateToString) required final DateTime date,
  }) = _$TourGuideRequestImpl;

  factory _TourGuideRequest.fromJson(Map<String, dynamic> json) =
      _$TourGuideRequestImpl.fromJson;

  @override
  String get cityId;
  @override
  String get districtId;
  @override
  String get tourPointId;
  @override
  @JsonKey(toJson: _dateToString)
  DateTime get date;

  /// Create a copy of TourGuideRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourGuideRequestImplCopyWith<_$TourGuideRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
