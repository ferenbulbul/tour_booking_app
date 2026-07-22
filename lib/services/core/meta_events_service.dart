import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

/// Central Meta (Facebook) App Events wrapper.
///
/// Reklam ölçümü için tek giriş noktası. App install/activate event'leri
/// SDK tarafından otomatik loglanır (FacebookAutoLogAppEventsEnabled). Custom
/// event'ler buradan geçer. `ServiceLocator` üzerinden erişilir.
class MetaEventsService {
  MetaEventsService._();
  static final MetaEventsService instance = MetaEventsService._();

  final FacebookAppEvents _fb = FacebookAppEvents();

  /// Uygulama açılışında çağrılır.
  Future<void> init() async {
    await _fb.setAutoLogAppEventsEnabled(true);
    // Advertiser ID: Android'de (GAID) açık — popup gerektirmez, daha iyi
    // attribution. iOS'ta kapalı — IDFA toplamak ATT popup'ı gerektirdiği için
    // "no tracking" modundayız; event'ler yine SKAdNetwork ile ölçülür.
    await _fb.setAdvertiserIdCollectionEnabled(!Platform.isIOS);
  }

  /// Genel amaçlı custom event.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
    double? valueToSum,
  }) async {
    await _fb.logEvent(
      name: name,
      parameters: parameters,
      valueToSum: valueToSum,
    );
  }

  /// Satın alma event'i (reklam optimizasyonu için kritik).
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, Object>? parameters,
  }) async {
    await _fb.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  /// Giriş yapan kullanıcıyı Meta'ya bağlar (id only).
  Future<void> setUser(String userId) => _fb.setUserID(userId);

  /// Çıkışta kullanıcı bağını temizler.
  Future<void> clearUser() => _fb.clearUserID();

  /// Bekleyen event'leri hemen gönder (test/doğrulama için).
  Future<void> flush() async {
    await _fb.flush();
    debugPrint('[MetaEvents] flush çağrıldı');
  }
}
