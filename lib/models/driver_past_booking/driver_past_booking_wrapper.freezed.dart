// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_past_booking_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverPastBookingWrapper _$DriverPastBookingWrapperFromJson(
  Map<String, dynamic> json,
) {
  return _DriverPastBookingWrapper.fromJson(json);
}

/// @nodoc
mixin _$DriverPastBookingWrapper {
  List<DriverPastBooking> get bookings => throw _privateConstructorUsedError;

  /// Serializes this DriverPastBookingWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverPastBookingWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverPastBookingWrapperCopyWith<DriverPastBookingWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverPastBookingWrapperCopyWith<$Res> {
  factory $DriverPastBookingWrapperCopyWith(
    DriverPastBookingWrapper value,
    $Res Function(DriverPastBookingWrapper) then,
  ) = _$DriverPastBookingWrapperCopyWithImpl<$Res, DriverPastBookingWrapper>;
  @useResult
  $Res call({List<DriverPastBooking> bookings});
}

/// @nodoc
class _$DriverPastBookingWrapperCopyWithImpl<
  $Res,
  $Val extends DriverPastBookingWrapper
>
    implements $DriverPastBookingWrapperCopyWith<$Res> {
  _$DriverPastBookingWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverPastBookingWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookings = null}) {
    return _then(
      _value.copyWith(
            bookings: null == bookings
                ? _value.bookings
                : bookings // ignore: cast_nullable_to_non_nullable
                      as List<DriverPastBooking>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverPastBookingWrapperImplCopyWith<$Res>
    implements $DriverPastBookingWrapperCopyWith<$Res> {
  factory _$$DriverPastBookingWrapperImplCopyWith(
    _$DriverPastBookingWrapperImpl value,
    $Res Function(_$DriverPastBookingWrapperImpl) then,
  ) = __$$DriverPastBookingWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DriverPastBooking> bookings});
}

/// @nodoc
class __$$DriverPastBookingWrapperImplCopyWithImpl<$Res>
    extends
        _$DriverPastBookingWrapperCopyWithImpl<
          $Res,
          _$DriverPastBookingWrapperImpl
        >
    implements _$$DriverPastBookingWrapperImplCopyWith<$Res> {
  __$$DriverPastBookingWrapperImplCopyWithImpl(
    _$DriverPastBookingWrapperImpl _value,
    $Res Function(_$DriverPastBookingWrapperImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverPastBookingWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookings = null}) {
    return _then(
      _$DriverPastBookingWrapperImpl(
        bookings: null == bookings
            ? _value._bookings
            : bookings // ignore: cast_nullable_to_non_nullable
                  as List<DriverPastBooking>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverPastBookingWrapperImpl implements _DriverPastBookingWrapper {
  const _$DriverPastBookingWrapperImpl({
    required final List<DriverPastBooking> bookings,
  }) : _bookings = bookings;

  factory _$DriverPastBookingWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverPastBookingWrapperImplFromJson(json);

  final List<DriverPastBooking> _bookings;
  @override
  List<DriverPastBooking> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  String toString() {
    return 'DriverPastBookingWrapper(bookings: $bookings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverPastBookingWrapperImpl &&
            const DeepCollectionEquality().equals(other._bookings, _bookings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_bookings));

  /// Create a copy of DriverPastBookingWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverPastBookingWrapperImplCopyWith<_$DriverPastBookingWrapperImpl>
  get copyWith =>
      __$$DriverPastBookingWrapperImplCopyWithImpl<
        _$DriverPastBookingWrapperImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverPastBookingWrapperImplToJson(this);
  }
}

abstract class _DriverPastBookingWrapper implements DriverPastBookingWrapper {
  const factory _DriverPastBookingWrapper({
    required final List<DriverPastBooking> bookings,
  }) = _$DriverPastBookingWrapperImpl;

  factory _DriverPastBookingWrapper.fromJson(Map<String, dynamic> json) =
      _$DriverPastBookingWrapperImpl.fromJson;

  @override
  List<DriverPastBooking> get bookings;

  /// Create a copy of DriverPastBookingWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverPastBookingWrapperImplCopyWith<_$DriverPastBookingWrapperImpl>
  get copyWith => throw _privateConstructorUsedError;
}
