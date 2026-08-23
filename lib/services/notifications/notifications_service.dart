import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/notifications/user_notification_dto.dart';
import 'package:tour_booking/services/core/api_client.dart';

/// Uygulama içi bildirim kutusu (zil ikonu) API çağrıları.
class NotificationsService {
  final ApiClient _apiClient;

  NotificationsService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<NotificationListDto>> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) {
    return _apiClient.get<NotificationListDto>(
      path: '/Mobile/notifications',
      queryParams: {'page': '$page', 'pageSize': '$pageSize'},
      fromJson: (json) =>
          NotificationListDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<int>> getUnreadCount() {
    return _apiClient.get<int>(
      path: '/Mobile/notifications/unread-count',
      fromJson: (json) => (json as num).toInt(),
    );
  }

  Future<BaseResponse<void>> markRead(String id) {
    return _apiClient.post<void>(path: '/Mobile/notifications/$id/read');
  }

  Future<BaseResponse<void>> markAllRead() {
    return _apiClient.post<void>(path: '/Mobile/notifications/read-all');
  }

  Future<BaseResponse<void>> deleteNotification(String id) {
    return _apiClient.delete<void>(path: '/Mobile/notifications/$id');
  }
}
