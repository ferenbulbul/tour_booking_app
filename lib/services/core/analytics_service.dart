import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Central Firebase Analytics (GA4) wrapper.
///
/// Tek giriş noktası: tüm event'ler buradan geçer. `ServiceLocator` üzerinden
/// erişilir, ekran takibi için [observer] GoRouter'a bağlanır.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// GoRouter'a eklenince ekran geçişlerini otomatik `screen_view` olarak yollar.
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Uygulama açılışında çağrılır. Debug'ta da veri toplamayı açık tutar.
  Future<void> init() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  /// Genel amaçlı custom event.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// Manuel ekran görüntüleme (observer dışında özel durumlar için).
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Giriş yapan kullanıcıyı GA4'e bağlar (PII gönderme — sadece id).
  Future<void> setUser({required String userId, String? role}) async {
    await _analytics.setUserId(id: userId);
    if (role != null) {
      await _analytics.setUserProperty(name: 'role', value: role);
    }
  }

  /// Çıkışta kullanıcı bağını temizler.
  Future<void> clearUser() async {
    await _analytics.setUserId(id: null);
  }

  /// Hızlı doğrulama için test event'i (DebugView'da görünür).
  Future<void> logDebugPing() async {
    await logEvent('debug_ping', parameters: {
      'source': 'manual_verify',
    });
    debugPrint('[Analytics] debug_ping gönderildi');
  }
}
