import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/models/notifications/user_notification_dto.dart';
import 'package:tour_booking/services/notifications/notifications_service.dart';

/// Uygulama içi bildirim kutusu — liste, okunmamış rozeti ve okundu işaretleme.
class NotificationsViewModel extends ChangeNotifier {
  final NotificationsService _service =
      ServiceLocator.instance.notificationsService;

  bool isLoading = false;
  String? errorMessage;
  List<UserNotificationDto> items = [];
  int unreadCount = 0;

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getNotifications(pageSize: 50);
      if (response.data != null) {
        // freezed/json listesi değiştirilemez — okundu işaretleme için kopyala
        items = List.of(response.data!.items);
        unreadCount = response.data!.unreadCount;
      } else {
        errorMessage = response.message ?? tr('error_generic');
      }
    } catch (_) {
      errorMessage = tr('error_generic');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Zil rozetini günceller (ana sayfa açılışında hafif çağrı).
  Future<void> refreshUnreadCount() async {
    try {
      final response = await _service.getUnreadCount();
      if (response.data != null && response.data != unreadCount) {
        unreadCount = response.data!;
        notifyListeners();
      }
    } catch (_) {
      // Rozet güncellenemezse sessiz geç — kritik değil
    }
  }

  Future<void> markRead(UserNotificationDto item) async {
    if (item.isRead) return;
    // Optimistic: önce UI'da okundu göster, API arkadan gelsin
    final index = items.indexWhere((n) => n.id == item.id);
    if (index != -1) {
      final updated = List.of(items);
      updated[index] = updated[index].copyWith(isRead: true);
      items = updated;
      if (unreadCount > 0) unreadCount--;
      notifyListeners();
    }
    try {
      await _service.markRead(item.id);
    } catch (_) {
      // Başarısız olsa bile bir sonraki fetch doğru durumu getirir
    }
  }

  Future<void> markAllRead() async {
    if (unreadCount == 0) return;
    items = [for (final n in items) n.copyWith(isRead: true)];
    unreadCount = 0;
    notifyListeners();
    try {
      await _service.markAllRead();
    } catch (_) {
      // Başarısız olsa bile bir sonraki fetch doğru durumu getirir
    }
  }
}
