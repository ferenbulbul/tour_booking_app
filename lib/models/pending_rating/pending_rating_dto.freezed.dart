// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_rating_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PendingRatingDto _$PendingRatingDtoFromJson(Map<String, dynamic> json) {
  return _PendingRatingDto.fromJson(json);
}

/// @nodoc
mixin _$PendingRatingDto {
  String get ratingRequestId => throw _privateConstructorUsedError;
  List<PendingRatingTargetDto> get targets =>
      throw _privateConstructorUsedError;

  /// Serializes this PendingRatingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingRatingDtoCopyWith<PendingRatingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingRatingDtoCopyWith<$Res> {
  factory $PendingRatingDtoCopyWith(
    PendingRatingDto value,
    $Res Function(PendingRatingDto) then,
  ) = _$PendingRatingDtoCopyWithImpl<$Res, PendingRatingDto>;
  @useResult
  $Res call({String ratingRequestId, List<PendingRatingTargetDto> targets});
}

/// @nodoc
class _$PendingRatingDtoCopyWithImpl<$Res, $Val extends PendingRatingDto>
    implements $PendingRatingDtoCopyWith<$Res> {
  _$PendingRatingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ratingRequestId = null, Object? targets = null}) {
    return _then(
      _value.copyWith(
            ratingRequestId: null == ratingRequestId
                ? _value.ratingRequestId
                : ratingRequestId // ignore: cast_nullable_to_non_nullable
                      as String,
            targets: null == targets
                ? _value.targets
                : targets // ignore: cast_nullable_to_non_nullable
                      as List<PendingRatingTargetDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PendingRatingDtoImplCopyWith<$Res>
    implements $PendingRatingDtoCopyWith<$Res> {
  factory _$$PendingRatingDtoImplCopyWith(
    _$PendingRatingDtoImpl value,
    $Res Function(_$PendingRatingDtoImpl) then,
  ) = __$$PendingRatingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ratingRequestId, List<PendingRatingTargetDto> targets});
}

/// @nodoc
class __$$PendingRatingDtoImplCopyWithImpl<$Res>
    extends _$PendingRatingDtoCopyWithImpl<$Res, _$PendingRatingDtoImpl>
    implements _$$PendingRatingDtoImplCopyWith<$Res> {
  __$$PendingRatingDtoImplCopyWithImpl(
    _$PendingRatingDtoImpl _value,
    $Res Function(_$PendingRatingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ratingRequestId = null, Object? targets = null}) {
    return _then(
      _$PendingRatingDtoImpl(
        ratingRequestId: null == ratingRequestId
            ? _value.ratingRequestId
            : ratingRequestId // ignore: cast_nullable_to_non_nullable
                  as String,
        targets: null == targets
            ? _value._targets
            : targets // ignore: cast_nullable_to_non_nullable
                  as List<PendingRatingTargetDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingRatingDtoImpl implements _PendingRatingDto {
  const _$PendingRatingDtoImpl({
    required this.ratingRequestId,
    required final List<PendingRatingTargetDto> targets,
  }) : _targets = targets;

  factory _$PendingRatingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingRatingDtoImplFromJson(json);

  @override
  final String ratingRequestId;
  final List<PendingRatingTargetDto> _targets;
  @override
  List<PendingRatingTargetDto> get targets {
    if (_targets is EqualUnmodifiableListView) return _targets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targets);
  }

  @override
  String toString() {
    return 'PendingRatingDto(ratingRequestId: $ratingRequestId, targets: $targets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingRatingDtoImpl &&
            (identical(other.ratingRequestId, ratingRequestId) ||
                other.ratingRequestId == ratingRequestId) &&
            const DeepCollectionEquality().equals(other._targets, _targets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ratingRequestId,
    const DeepCollectionEquality().hash(_targets),
  );

  /// Create a copy of PendingRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingRatingDtoImplCopyWith<_$PendingRatingDtoImpl> get copyWith =>
      __$$PendingRatingDtoImplCopyWithImpl<_$PendingRatingDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingRatingDtoImplToJson(this);
  }
}

abstract class _PendingRatingDto implements PendingRatingDto {
  const factory _PendingRatingDto({
    required final String ratingRequestId,
    required final List<PendingRatingTargetDto> targets,
  }) = _$PendingRatingDtoImpl;

  factory _PendingRatingDto.fromJson(Map<String, dynamic> json) =
      _$PendingRatingDtoImpl.fromJson;

  @override
  String get ratingRequestId;
  @override
  List<PendingRatingTargetDto> get targets;

  /// Create a copy of PendingRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingRatingDtoImplCopyWith<_$PendingRatingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PendingRatingTargetDto _$PendingRatingTargetDtoFromJson(
  Map<String, dynamic> json,
) {
  return _PendingRatingTargetDto.fromJson(json);
}

/// @nodoc
mixin _$PendingRatingTargetDto {
  int get targetType => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this PendingRatingTargetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingRatingTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingRatingTargetDtoCopyWith<PendingRatingTargetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingRatingTargetDtoCopyWith<$Res> {
  factory $PendingRatingTargetDtoCopyWith(
    PendingRatingTargetDto value,
    $Res Function(PendingRatingTargetDto) then,
  ) = _$PendingRatingTargetDtoCopyWithImpl<$Res, PendingRatingTargetDto>;
  @useResult
  $Res call({int targetType, String targetId, String displayName});
}

/// @nodoc
class _$PendingRatingTargetDtoCopyWithImpl<
  $Res,
  $Val extends PendingRatingTargetDto
>
    implements $PendingRatingTargetDtoCopyWith<$Res> {
  _$PendingRatingTargetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingRatingTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetType = null,
    Object? targetId = null,
    Object? displayName = null,
  }) {
    return _then(
      _value.copyWith(
            targetType: null == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as int,
            targetId: null == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PendingRatingTargetDtoImplCopyWith<$Res>
    implements $PendingRatingTargetDtoCopyWith<$Res> {
  factory _$$PendingRatingTargetDtoImplCopyWith(
    _$PendingRatingTargetDtoImpl value,
    $Res Function(_$PendingRatingTargetDtoImpl) then,
  ) = __$$PendingRatingTargetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int targetType, String targetId, String displayName});
}

/// @nodoc
class __$$PendingRatingTargetDtoImplCopyWithImpl<$Res>
    extends
        _$PendingRatingTargetDtoCopyWithImpl<$Res, _$PendingRatingTargetDtoImpl>
    implements _$$PendingRatingTargetDtoImplCopyWith<$Res> {
  __$$PendingRatingTargetDtoImplCopyWithImpl(
    _$PendingRatingTargetDtoImpl _value,
    $Res Function(_$PendingRatingTargetDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingRatingTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetType = null,
    Object? targetId = null,
    Object? displayName = null,
  }) {
    return _then(
      _$PendingRatingTargetDtoImpl(
        targetType: null == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as int,
        targetId: null == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingRatingTargetDtoImpl implements _PendingRatingTargetDto {
  const _$PendingRatingTargetDtoImpl({
    required this.targetType,
    required this.targetId,
    required this.displayName,
  });

  factory _$PendingRatingTargetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingRatingTargetDtoImplFromJson(json);

  @override
  final int targetType;
  @override
  final String targetId;
  @override
  final String displayName;

  @override
  String toString() {
    return 'PendingRatingTargetDto(targetType: $targetType, targetId: $targetId, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingRatingTargetDtoImpl &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetType, targetId, displayName);

  /// Create a copy of PendingRatingTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingRatingTargetDtoImplCopyWith<_$PendingRatingTargetDtoImpl>
  get copyWith =>
      __$$PendingRatingTargetDtoImplCopyWithImpl<_$PendingRatingTargetDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingRatingTargetDtoImplToJson(this);
  }
}

abstract class _PendingRatingTargetDto implements PendingRatingTargetDto {
  const factory _PendingRatingTargetDto({
    required final int targetType,
    required final String targetId,
    required final String displayName,
  }) = _$PendingRatingTargetDtoImpl;

  factory _PendingRatingTargetDto.fromJson(Map<String, dynamic> json) =
      _$PendingRatingTargetDtoImpl.fromJson;

  @override
  int get targetType;
  @override
  String get targetId;
  @override
  String get displayName;

  /// Create a copy of PendingRatingTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingRatingTargetDtoImplCopyWith<_$PendingRatingTargetDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
