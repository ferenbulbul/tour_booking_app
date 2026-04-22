// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_vehicles_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportSearchVehiclesRequest _$TransportSearchVehiclesRequestFromJson(
  Map<String, dynamic> json,
) {
  return _TransportSearchVehiclesRequest.fromJson(json);
}

/// @nodoc
mixin _$TransportSearchVehiclesRequest {
  String get cityId => throw _privateConstructorUsedError;
  String? get districtId => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateToString)
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  int get estimatedDurationMinutes => throw _privateConstructorUsedError;

  /// Serializes this TransportSearchVehiclesRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportSearchVehiclesRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportSearchVehiclesRequestCopyWith<TransportSearchVehiclesRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportSearchVehiclesRequestCopyWith<$Res> {
  factory $TransportSearchVehiclesRequestCopyWith(
    TransportSearchVehiclesRequest value,
    $Res Function(TransportSearchVehiclesRequest) then,
  ) =
      _$TransportSearchVehiclesRequestCopyWithImpl<
        $Res,
        TransportSearchVehiclesRequest
      >;
  @useResult
  $Res call({
    String cityId,
    String? districtId,
    @JsonKey(toJson: _dateToString) DateTime date,
    String startTime,
    int estimatedDurationMinutes,
  });
}

/// @nodoc
class _$TransportSearchVehiclesRequestCopyWithImpl<
  $Res,
  $Val extends TransportSearchVehiclesRequest
>
    implements $TransportSearchVehiclesRequestCopyWith<$Res> {
  _$TransportSearchVehiclesRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportSearchVehiclesRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityId = null,
    Object? districtId = freezed,
    Object? date = null,
    Object? startTime = null,
    Object? estimatedDurationMinutes = null,
  }) {
    return _then(
      _value.copyWith(
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            districtId: freezed == districtId
                ? _value.districtId
                : districtId // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedDurationMinutes: null == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportSearchVehiclesRequestImplCopyWith<$Res>
    implements $TransportSearchVehiclesRequestCopyWith<$Res> {
  factory _$$TransportSearchVehiclesRequestImplCopyWith(
    _$TransportSearchVehiclesRequestImpl value,
    $Res Function(_$TransportSearchVehiclesRequestImpl) then,
  ) = __$$TransportSearchVehiclesRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cityId,
    String? districtId,
    @JsonKey(toJson: _dateToString) DateTime date,
    String startTime,
    int estimatedDurationMinutes,
  });
}

/// @nodoc
class __$$TransportSearchVehiclesRequestImplCopyWithImpl<$Res>
    extends
        _$TransportSearchVehiclesRequestCopyWithImpl<
          $Res,
          _$TransportSearchVehiclesRequestImpl
        >
    implements _$$TransportSearchVehiclesRequestImplCopyWith<$Res> {
  __$$TransportSearchVehiclesRequestImplCopyWithImpl(
    _$TransportSearchVehiclesRequestImpl _value,
    $Res Function(_$TransportSearchVehiclesRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportSearchVehiclesRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityId = null,
    Object? districtId = freezed,
    Object? date = null,
    Object? startTime = null,
    Object? estimatedDurationMinutes = null,
  }) {
    return _then(
      _$TransportSearchVehiclesRequestImpl(
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        districtId: freezed == districtId
            ? _value.districtId
            : districtId // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedDurationMinutes: null == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportSearchVehiclesRequestImpl
    implements _TransportSearchVehiclesRequest {
  const _$TransportSearchVehiclesRequestImpl({
    required this.cityId,
    this.districtId,
    @JsonKey(toJson: _dateToString) required this.date,
    required this.startTime,
    this.estimatedDurationMinutes = 60,
  });

  factory _$TransportSearchVehiclesRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TransportSearchVehiclesRequestImplFromJson(json);

  @override
  final String cityId;
  @override
  final String? districtId;
  @override
  @JsonKey(toJson: _dateToString)
  final DateTime date;
  @override
  final String startTime;
  @override
  @JsonKey()
  final int estimatedDurationMinutes;

  @override
  String toString() {
    return 'TransportSearchVehiclesRequest(cityId: $cityId, districtId: $districtId, date: $date, startTime: $startTime, estimatedDurationMinutes: $estimatedDurationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportSearchVehiclesRequestImpl &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cityId,
    districtId,
    date,
    startTime,
    estimatedDurationMinutes,
  );

  /// Create a copy of TransportSearchVehiclesRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportSearchVehiclesRequestImplCopyWith<
    _$TransportSearchVehiclesRequestImpl
  >
  get copyWith =>
      __$$TransportSearchVehiclesRequestImplCopyWithImpl<
        _$TransportSearchVehiclesRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportSearchVehiclesRequestImplToJson(this);
  }
}

abstract class _TransportSearchVehiclesRequest
    implements TransportSearchVehiclesRequest {
  const factory _TransportSearchVehiclesRequest({
    required final String cityId,
    final String? districtId,
    @JsonKey(toJson: _dateToString) required final DateTime date,
    required final String startTime,
    final int estimatedDurationMinutes,
  }) = _$TransportSearchVehiclesRequestImpl;

  factory _TransportSearchVehiclesRequest.fromJson(Map<String, dynamic> json) =
      _$TransportSearchVehiclesRequestImpl.fromJson;

  @override
  String get cityId;
  @override
  String? get districtId;
  @override
  @JsonKey(toJson: _dateToString)
  DateTime get date;
  @override
  String get startTime;
  @override
  int get estimatedDurationMinutes;

  /// Create a copy of TransportSearchVehiclesRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportSearchVehiclesRequestImplCopyWith<
    _$TransportSearchVehiclesRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
