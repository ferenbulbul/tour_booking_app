// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_me.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserMe _$UserMeFromJson(Map<String, dynamic> json) {
  return _UserMe.fromJson(json);
}

/// @nodoc
mixin _$UserMe {
  String? get userId => throw _privateConstructorUsedError;
  bool get emailConfirmed => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;

  /// Serializes this UserMe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserMe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserMeCopyWith<UserMe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMeCopyWith<$Res> {
  factory $UserMeCopyWith(UserMe value, $Res Function(UserMe) then) =
      _$UserMeCopyWithImpl<$Res, UserMe>;
  @useResult
  $Res call({String? userId, bool emailConfirmed, String? firstName});
}

/// @nodoc
class _$UserMeCopyWithImpl<$Res, $Val extends UserMe>
    implements $UserMeCopyWith<$Res> {
  _$UserMeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserMe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? emailConfirmed = null,
    Object? firstName = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            emailConfirmed: null == emailConfirmed
                ? _value.emailConfirmed
                : emailConfirmed // ignore: cast_nullable_to_non_nullable
                      as bool,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserMeImplCopyWith<$Res> implements $UserMeCopyWith<$Res> {
  factory _$$UserMeImplCopyWith(
    _$UserMeImpl value,
    $Res Function(_$UserMeImpl) then,
  ) = __$$UserMeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? userId, bool emailConfirmed, String? firstName});
}

/// @nodoc
class __$$UserMeImplCopyWithImpl<$Res>
    extends _$UserMeCopyWithImpl<$Res, _$UserMeImpl>
    implements _$$UserMeImplCopyWith<$Res> {
  __$$UserMeImplCopyWithImpl(
    _$UserMeImpl _value,
    $Res Function(_$UserMeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserMe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? emailConfirmed = null,
    Object? firstName = freezed,
  }) {
    return _then(
      _$UserMeImpl(
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        emailConfirmed: null == emailConfirmed
            ? _value.emailConfirmed
            : emailConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMeImpl implements _UserMe {
  const _$UserMeImpl({
    this.userId,
    required this.emailConfirmed,
    this.firstName,
  });

  factory _$UserMeImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMeImplFromJson(json);

  @override
  final String? userId;
  @override
  final bool emailConfirmed;
  @override
  final String? firstName;

  @override
  String toString() {
    return 'UserMe(userId: $userId, emailConfirmed: $emailConfirmed, firstName: $firstName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMeImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.emailConfirmed, emailConfirmed) ||
                other.emailConfirmed == emailConfirmed) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, emailConfirmed, firstName);

  /// Create a copy of UserMe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMeImplCopyWith<_$UserMeImpl> get copyWith =>
      __$$UserMeImplCopyWithImpl<_$UserMeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMeImplToJson(this);
  }
}

abstract class _UserMe implements UserMe {
  const factory _UserMe({
    final String? userId,
    required final bool emailConfirmed,
    final String? firstName,
  }) = _$UserMeImpl;

  factory _UserMe.fromJson(Map<String, dynamic> json) = _$UserMeImpl.fromJson;

  @override
  String? get userId;
  @override
  bool get emailConfirmed;
  @override
  String? get firstName;

  /// Create a copy of UserMe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMeImplCopyWith<_$UserMeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
