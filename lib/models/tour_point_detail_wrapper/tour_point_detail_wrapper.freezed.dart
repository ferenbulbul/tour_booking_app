// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_point_detail_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourPointDetailWrapper _$TourPointDetailWrapperFromJson(
  Map<String, dynamic> json,
) {
  return _TourPointDetailWrapper.fromJson(json);
}

/// @nodoc
mixin _$TourPointDetailWrapper {
  TourPointDetail get tourPointDetails => throw _privateConstructorUsedError;

  /// Serializes this TourPointDetailWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourPointDetailWrapperCopyWith<TourPointDetailWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourPointDetailWrapperCopyWith<$Res> {
  factory $TourPointDetailWrapperCopyWith(
    TourPointDetailWrapper value,
    $Res Function(TourPointDetailWrapper) then,
  ) = _$TourPointDetailWrapperCopyWithImpl<$Res, TourPointDetailWrapper>;
  @useResult
  $Res call({TourPointDetail tourPointDetails});

  $TourPointDetailCopyWith<$Res> get tourPointDetails;
}

/// @nodoc
class _$TourPointDetailWrapperCopyWithImpl<
  $Res,
  $Val extends TourPointDetailWrapper
>
    implements $TourPointDetailWrapperCopyWith<$Res> {
  _$TourPointDetailWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPointDetails = null}) {
    return _then(
      _value.copyWith(
            tourPointDetails: null == tourPointDetails
                ? _value.tourPointDetails
                : tourPointDetails // ignore: cast_nullable_to_non_nullable
                      as TourPointDetail,
          )
          as $Val,
    );
  }

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TourPointDetailCopyWith<$Res> get tourPointDetails {
    return $TourPointDetailCopyWith<$Res>(_value.tourPointDetails, (value) {
      return _then(_value.copyWith(tourPointDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TourPointDetailWrapperImplCopyWith<$Res>
    implements $TourPointDetailWrapperCopyWith<$Res> {
  factory _$$TourPointDetailWrapperImplCopyWith(
    _$TourPointDetailWrapperImpl value,
    $Res Function(_$TourPointDetailWrapperImpl) then,
  ) = __$$TourPointDetailWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TourPointDetail tourPointDetails});

  @override
  $TourPointDetailCopyWith<$Res> get tourPointDetails;
}

/// @nodoc
class __$$TourPointDetailWrapperImplCopyWithImpl<$Res>
    extends
        _$TourPointDetailWrapperCopyWithImpl<$Res, _$TourPointDetailWrapperImpl>
    implements _$$TourPointDetailWrapperImplCopyWith<$Res> {
  __$$TourPointDetailWrapperImplCopyWithImpl(
    _$TourPointDetailWrapperImpl _value,
    $Res Function(_$TourPointDetailWrapperImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tourPointDetails = null}) {
    return _then(
      _$TourPointDetailWrapperImpl(
        tourPointDetails: null == tourPointDetails
            ? _value.tourPointDetails
            : tourPointDetails // ignore: cast_nullable_to_non_nullable
                  as TourPointDetail,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourPointDetailWrapperImpl implements _TourPointDetailWrapper {
  const _$TourPointDetailWrapperImpl({required this.tourPointDetails});

  factory _$TourPointDetailWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourPointDetailWrapperImplFromJson(json);

  @override
  final TourPointDetail tourPointDetails;

  @override
  String toString() {
    return 'TourPointDetailWrapper(tourPointDetails: $tourPointDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourPointDetailWrapperImpl &&
            (identical(other.tourPointDetails, tourPointDetails) ||
                other.tourPointDetails == tourPointDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tourPointDetails);

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourPointDetailWrapperImplCopyWith<_$TourPointDetailWrapperImpl>
  get copyWith =>
      __$$TourPointDetailWrapperImplCopyWithImpl<_$TourPointDetailWrapperImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourPointDetailWrapperImplToJson(this);
  }
}

abstract class _TourPointDetailWrapper implements TourPointDetailWrapper {
  const factory _TourPointDetailWrapper({
    required final TourPointDetail tourPointDetails,
  }) = _$TourPointDetailWrapperImpl;

  factory _TourPointDetailWrapper.fromJson(Map<String, dynamic> json) =
      _$TourPointDetailWrapperImpl.fromJson;

  @override
  TourPointDetail get tourPointDetails;

  /// Create a copy of TourPointDetailWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourPointDetailWrapperImplCopyWith<_$TourPointDetailWrapperImpl>
  get copyWith => throw _privateConstructorUsedError;
}
