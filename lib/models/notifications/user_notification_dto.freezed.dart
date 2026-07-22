// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_notification_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationListDto _$NotificationListDtoFromJson(Map<String, dynamic> json) {
  return _NotificationListDto.fromJson(json);
}

/// @nodoc
mixin _$NotificationListDto {
  List<UserNotificationDto> get items => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this NotificationListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationListDtoCopyWith<NotificationListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationListDtoCopyWith<$Res> {
  factory $NotificationListDtoCopyWith(
    NotificationListDto value,
    $Res Function(NotificationListDto) then,
  ) = _$NotificationListDtoCopyWithImpl<$Res, NotificationListDto>;
  @useResult
  $Res call({List<UserNotificationDto> items, int totalCount, int unreadCount});
}

/// @nodoc
class _$NotificationListDtoCopyWithImpl<$Res, $Val extends NotificationListDto>
    implements $NotificationListDtoCopyWith<$Res> {
  _$NotificationListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalCount = null,
    Object? unreadCount = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<UserNotificationDto>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationListDtoImplCopyWith<$Res>
    implements $NotificationListDtoCopyWith<$Res> {
  factory _$$NotificationListDtoImplCopyWith(
    _$NotificationListDtoImpl value,
    $Res Function(_$NotificationListDtoImpl) then,
  ) = __$$NotificationListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserNotificationDto> items, int totalCount, int unreadCount});
}

/// @nodoc
class __$$NotificationListDtoImplCopyWithImpl<$Res>
    extends _$NotificationListDtoCopyWithImpl<$Res, _$NotificationListDtoImpl>
    implements _$$NotificationListDtoImplCopyWith<$Res> {
  __$$NotificationListDtoImplCopyWithImpl(
    _$NotificationListDtoImpl _value,
    $Res Function(_$NotificationListDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalCount = null,
    Object? unreadCount = null,
  }) {
    return _then(
      _$NotificationListDtoImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<UserNotificationDto>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationListDtoImpl implements _NotificationListDto {
  const _$NotificationListDtoImpl({
    required final List<UserNotificationDto> items,
    required this.totalCount,
    required this.unreadCount,
  }) : _items = items;

  factory _$NotificationListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationListDtoImplFromJson(json);

  final List<UserNotificationDto> _items;
  @override
  List<UserNotificationDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int totalCount;
  @override
  final int unreadCount;

  @override
  String toString() {
    return 'NotificationListDto(items: $items, totalCount: $totalCount, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationListDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    totalCount,
    unreadCount,
  );

  /// Create a copy of NotificationListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationListDtoImplCopyWith<_$NotificationListDtoImpl> get copyWith =>
      __$$NotificationListDtoImplCopyWithImpl<_$NotificationListDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationListDtoImplToJson(this);
  }
}

abstract class _NotificationListDto implements NotificationListDto {
  const factory _NotificationListDto({
    required final List<UserNotificationDto> items,
    required final int totalCount,
    required final int unreadCount,
  }) = _$NotificationListDtoImpl;

  factory _NotificationListDto.fromJson(Map<String, dynamic> json) =
      _$NotificationListDtoImpl.fromJson;

  @override
  List<UserNotificationDto> get items;
  @override
  int get totalCount;
  @override
  int get unreadCount;

  /// Create a copy of NotificationListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationListDtoImplCopyWith<_$NotificationListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserNotificationDto _$UserNotificationDtoFromJson(Map<String, dynamic> json) {
  return _UserNotificationDto.fromJson(json);
}

/// @nodoc
mixin _$UserNotificationDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get deepLink => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserNotificationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserNotificationDtoCopyWith<UserNotificationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNotificationDtoCopyWith<$Res> {
  factory $UserNotificationDtoCopyWith(
    UserNotificationDto value,
    $Res Function(UserNotificationDto) then,
  ) = _$UserNotificationDtoCopyWithImpl<$Res, UserNotificationDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    String? imageUrl,
    String? deepLink,
    bool isRead,
    DateTime createdAt,
  });
}

/// @nodoc
class _$UserNotificationDtoCopyWithImpl<$Res, $Val extends UserNotificationDto>
    implements $UserNotificationDtoCopyWith<$Res> {
  _$UserNotificationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? imageUrl = freezed,
    Object? deepLink = freezed,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            deepLink: freezed == deepLink
                ? _value.deepLink
                : deepLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserNotificationDtoImplCopyWith<$Res>
    implements $UserNotificationDtoCopyWith<$Res> {
  factory _$$UserNotificationDtoImplCopyWith(
    _$UserNotificationDtoImpl value,
    $Res Function(_$UserNotificationDtoImpl) then,
  ) = __$$UserNotificationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    String? imageUrl,
    String? deepLink,
    bool isRead,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$UserNotificationDtoImplCopyWithImpl<$Res>
    extends _$UserNotificationDtoCopyWithImpl<$Res, _$UserNotificationDtoImpl>
    implements _$$UserNotificationDtoImplCopyWith<$Res> {
  __$$UserNotificationDtoImplCopyWithImpl(
    _$UserNotificationDtoImpl _value,
    $Res Function(_$UserNotificationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? imageUrl = freezed,
    Object? deepLink = freezed,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$UserNotificationDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        deepLink: freezed == deepLink
            ? _value.deepLink
            : deepLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNotificationDtoImpl implements _UserNotificationDto {
  const _$UserNotificationDtoImpl({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    this.deepLink,
    required this.isRead,
    required this.createdAt,
  });

  factory _$UserNotificationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNotificationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  @override
  final String? imageUrl;
  @override
  final String? deepLink;
  @override
  final bool isRead;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserNotificationDto(id: $id, title: $title, message: $message, imageUrl: $imageUrl, deepLink: $deepLink, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNotificationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.deepLink, deepLink) ||
                other.deepLink == deepLink) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    message,
    imageUrl,
    deepLink,
    isRead,
    createdAt,
  );

  /// Create a copy of UserNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNotificationDtoImplCopyWith<_$UserNotificationDtoImpl> get copyWith =>
      __$$UserNotificationDtoImplCopyWithImpl<_$UserNotificationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNotificationDtoImplToJson(this);
  }
}

abstract class _UserNotificationDto implements UserNotificationDto {
  const factory _UserNotificationDto({
    required final String id,
    required final String title,
    required final String message,
    final String? imageUrl,
    final String? deepLink,
    required final bool isRead,
    required final DateTime createdAt,
  }) = _$UserNotificationDtoImpl;

  factory _UserNotificationDto.fromJson(Map<String, dynamic> json) =
      _$UserNotificationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get message;
  @override
  String? get imageUrl;
  @override
  String? get deepLink;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;

  /// Create a copy of UserNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserNotificationDtoImplCopyWith<_$UserNotificationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
