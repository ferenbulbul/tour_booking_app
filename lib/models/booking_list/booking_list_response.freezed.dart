// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingListResponse _$BookingListResponseFromJson(Map<String, dynamic> json) {
  return _BookingListResponse.fromJson(json);
}

/// @nodoc
mixin _$BookingListResponse {
  List<BookingDto> get customerBookings => throw _privateConstructorUsedError;

  /// Serializes this BookingListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingListResponseCopyWith<BookingListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingListResponseCopyWith<$Res> {
  factory $BookingListResponseCopyWith(
    BookingListResponse value,
    $Res Function(BookingListResponse) then,
  ) = _$BookingListResponseCopyWithImpl<$Res, BookingListResponse>;
  @useResult
  $Res call({List<BookingDto> customerBookings});
}

/// @nodoc
class _$BookingListResponseCopyWithImpl<$Res, $Val extends BookingListResponse>
    implements $BookingListResponseCopyWith<$Res> {
  _$BookingListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerBookings = null}) {
    return _then(
      _value.copyWith(
            customerBookings: null == customerBookings
                ? _value.customerBookings
                : customerBookings // ignore: cast_nullable_to_non_nullable
                      as List<BookingDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingListResponseImplCopyWith<$Res>
    implements $BookingListResponseCopyWith<$Res> {
  factory _$$BookingListResponseImplCopyWith(
    _$BookingListResponseImpl value,
    $Res Function(_$BookingListResponseImpl) then,
  ) = __$$BookingListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BookingDto> customerBookings});
}

/// @nodoc
class __$$BookingListResponseImplCopyWithImpl<$Res>
    extends _$BookingListResponseCopyWithImpl<$Res, _$BookingListResponseImpl>
    implements _$$BookingListResponseImplCopyWith<$Res> {
  __$$BookingListResponseImplCopyWithImpl(
    _$BookingListResponseImpl _value,
    $Res Function(_$BookingListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerBookings = null}) {
    return _then(
      _$BookingListResponseImpl(
        customerBookings: null == customerBookings
            ? _value._customerBookings
            : customerBookings // ignore: cast_nullable_to_non_nullable
                  as List<BookingDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingListResponseImpl implements _BookingListResponse {
  const _$BookingListResponseImpl({
    required final List<BookingDto> customerBookings,
  }) : _customerBookings = customerBookings;

  factory _$BookingListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingListResponseImplFromJson(json);

  final List<BookingDto> _customerBookings;
  @override
  List<BookingDto> get customerBookings {
    if (_customerBookings is EqualUnmodifiableListView)
      return _customerBookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customerBookings);
  }

  @override
  String toString() {
    return 'BookingListResponse(customerBookings: $customerBookings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingListResponseImpl &&
            const DeepCollectionEquality().equals(
              other._customerBookings,
              _customerBookings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_customerBookings),
  );

  /// Create a copy of BookingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingListResponseImplCopyWith<_$BookingListResponseImpl> get copyWith =>
      __$$BookingListResponseImplCopyWithImpl<_$BookingListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingListResponseImplToJson(this);
  }
}

abstract class _BookingListResponse implements BookingListResponse {
  const factory _BookingListResponse({
    required final List<BookingDto> customerBookings,
  }) = _$BookingListResponseImpl;

  factory _BookingListResponse.fromJson(Map<String, dynamic> json) =
      _$BookingListResponseImpl.fromJson;

  @override
  List<BookingDto> get customerBookings;

  /// Create a copy of BookingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingListResponseImplCopyWith<_$BookingListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
