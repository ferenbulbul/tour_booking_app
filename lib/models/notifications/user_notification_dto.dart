import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_notification_dto.freezed.dart';
part 'user_notification_dto.g.dart';

@freezed
class NotificationListDto with _$NotificationListDto {
  const factory NotificationListDto({
    required List<UserNotificationDto> items,
    required int totalCount,
    required int unreadCount,
  }) = _NotificationListDto;

  factory NotificationListDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationListDtoFromJson(json);
}

@freezed
class UserNotificationDto with _$UserNotificationDto {
  const factory UserNotificationDto({
    required String id,
    required String title,
    required String message,
    String? imageUrl,
    String? deepLink,
    required bool isRead,
    required DateTime createdAt,
  }) = _UserNotificationDto;

  factory UserNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationDtoFromJson(json);
}
