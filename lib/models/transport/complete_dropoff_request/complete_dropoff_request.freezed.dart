// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complete_dropoff_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransportCompleteDropoffRequest _$TransportCompleteDropoffRequestFromJson(
  Map<String, dynamic> json,
) {
  return _TransportCompleteDropoffRequest.fromJson(json);
}

/// @nodoc
mixin _$TransportCompleteDropoffRequest {
  String get bookingId => throw _privateConstructorUsedError;

  /// Serializes this TransportCompleteDropoffRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportCompleteDropoffRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportCompleteDropoffRequestCopyWith<TransportCompleteDropoffRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportCompleteDropoffRequestCopyWith<$Res> {
  factory $TransportCompleteDropoffRequestCopyWith(
    TransportCompleteDropoffRequest value,
    $Res Function(TransportCompleteDropoffRequest) then,
  ) =
      _$TransportCompleteDropoffRequestCopyWithImpl<
        $Res,
        TransportCompleteDropoffRequest
      >;
  @useResult
  $Res call({String bookingId});
}

/// @nodoc
class _$TransportCompleteDropoffRequestCopyWithImpl<
  $Res,
  $Val extends TransportCompleteDropoffRequest
>
    implements $TransportCompleteDropoffRequestCopyWith<$Res> {
  _$TransportCompleteDropoffRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportCompleteDropoffRequest
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
abstract class _$$TransportCompleteDropoffRequestImplCopyWith<$Res>
    implements $TransportCompleteDropoffRequestCopyWith<$Res> {
  factory _$$TransportCompleteDropoffRequestImplCopyWith(
    _$TransportCompleteDropoffRequestImpl value,
    $Res Function(_$TransportCompleteDropoffRequestImpl) then,
  ) = __$$TransportCompleteDropoffRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String bookingId});
}

/// @nodoc
class __$$TransportCompleteDropoffRequestImplCopyWithImpl<$Res>
    extends
        _$TransportCompleteDropoffRequestCopyWithImpl<
          $Res,
          _$TransportCompleteDropoffRequestImpl
        >
    implements _$$TransportCompleteDropoffRequestImplCopyWith<$Res> {
  __$$TransportCompleteDropoffRequestImplCopyWithImpl(
    _$TransportCompleteDropoffRequestImpl _value,
    $Res Function(_$TransportCompleteDropoffRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransportCompleteDropoffRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookingId = null}) {
    return _then(
      _$TransportCompleteDropoffRequestImpl(
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
class _$TransportCompleteDropoffRequestImpl
    implements _TransportCompleteDropoffRequest {
  const _$TransportCompleteDropoffRequestImpl({required this.bookingId});

  factory _$TransportCompleteDropoffRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TransportCompleteDropoffRequestImplFromJson(json);

  @override
  final String bookingId;

  @override
  String toString() {
    return 'TransportCompleteDropoffRequest(bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportCompleteDropoffRequestImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId);

  /// Create a copy of TransportCompleteDropoffRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportCompleteDropoffRequestImplCopyWith<
    _$TransportCompleteDropoffRequestImpl
  >
  get copyWith =>
      __$$TransportCompleteDropoffRequestImplCopyWithImpl<
        _$TransportCompleteDropoffRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportCompleteDropoffRequestImplToJson(this);
  }
}

abstract class _TransportCompleteDropoffRequest
    implements TransportCompleteDropoffRequest {
  const factory _TransportCompleteDropoffRequest({
    required final String bookingId,
  }) = _$TransportCompleteDropoffRequestImpl;

  factory _TransportCompleteDropoffRequest.fromJson(Map<String, dynamic> json) =
      _$TransportCompleteDropoffRequestImpl.fromJson;

  @override
  String get bookingId;

  /// Create a copy of TransportCompleteDropoffRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportCompleteDropoffRequestImplCopyWith<
    _$TransportCompleteDropoffRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
