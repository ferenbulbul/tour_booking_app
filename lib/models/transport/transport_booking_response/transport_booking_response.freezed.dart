// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_booking_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportBookingResponse _$TransportBookingResponseFromJson(
  Map<String, dynamic> json,
) {
  return _TransportBookingResponse.fromJson(json);
}

/// @nodoc
mixin _$TransportBookingResponse {
  String get bookingId => throw _privateConstructorUsedError;

  /// Serializes this TransportBookingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportBookingResponseCopyWith<TransportBookingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportBookingResponseCopyWith<$Res> {
  factory $TransportBookingResponseCopyWith(
    TransportBookingResponse value,
    $Res Function(TransportBookingResponse) then,
  ) = _$TransportBookingResponseCopyWithImpl<$Res, TransportBookingResponse>;
  @useResult
  $Res call({String bookingId});
}

/// @nodoc
class _$TransportBookingResponseCopyWithImpl<
  $Res,
  $Val extends TransportBookingResponse
>
    implements $TransportBookingResponseCopyWith<$Res> {
  _$TransportBookingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookingId = null}) {
    return _then(
      _value.copyWith(
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransportBookingResponseImplCopyWith<$Res>
    implements $TransportBookingResponseCopyWith<$Res> {
  factory _$$TransportBookingResponseImplCopyWith(
    _$TransportBookingResponseImpl value,
    $Res Function(_$TransportBookingResponseImpl) then,
  ) = __$$TransportBookingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String bookingId});
}

/// @nodoc
class __$$TransportBookingResponseImplCopyWithImpl<$Res>
    extends
        _$TransportBookingResponseCopyWithImpl<
          $Res,
          _$TransportBookingResponseImpl
        >
    implements _$$TransportBookingResponseImplCopyWith<$Res> {
  __$$TransportBookingResponseImplCopyWithImpl(
    _$TransportBookingResponseImpl _value,
    $Res Function(_$TransportBookingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookingId = null}) {
    return _then(
      _$TransportBookingResponseImpl(
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportBookingResponseImpl implements _TransportBookingResponse {
  const _$TransportBookingResponseImpl({required this.bookingId});

  factory _$TransportBookingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportBookingResponseImplFromJson(json);

  @override
  final String bookingId;

  @override
  String toString() {
    return 'TransportBookingResponse(bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportBookingResponseImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId);

  /// Create a copy of TransportBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportBookingResponseImplCopyWith<_$TransportBookingResponseImpl>
  get copyWith =>
      __$$TransportBookingResponseImplCopyWithImpl<
        _$TransportBookingResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportBookingResponseImplToJson(this);
  }
}

abstract class _TransportBookingResponse implements TransportBookingResponse {
  const factory _TransportBookingResponse({required final String bookingId}) =
      _$TransportBookingResponseImpl;

  factory _TransportBookingResponse.fromJson(Map<String, dynamic> json) =
      _$TransportBookingResponseImpl.fromJson;

  @override
  String get bookingId;

  /// Create a copy of TransportBookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportBookingResponseImplCopyWith<_$TransportBookingResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
