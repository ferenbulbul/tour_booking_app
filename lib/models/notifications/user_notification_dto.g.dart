// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationListDtoImpl _$$NotificationListDtoImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationListDtoImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => UserNotificationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$$NotificationListDtoImplToJson(
  _$NotificationListDtoImpl instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'totalCount': instance.totalCount,
  'unreadCount': instance.unreadCount,
};

_$UserNotificationDtoImpl _$$UserNotificationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UserNotificationDtoImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  imageUrl: json['imageUrl'] as String?,
  deepLink: json['deepLink'] as String?,
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$UserNotificationDtoImplToJson(
  _$UserNotificationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'imageUrl': instance.imageUrl,
  'deepLink': instance.deepLink,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};
