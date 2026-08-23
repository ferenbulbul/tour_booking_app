import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tour_booking/services/core/api_client.dart';

class SecureTokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    // Update in-memory cache FIRST so subsequent API calls use the new token
    ApiClient.updateTokenCache(accessToken, refreshToken);
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() => _readSelfHealing(_keyAccessToken);

  Future<String?> getRefreshToken() => _readSelfHealing(_keyRefreshToken);

  /// KENDİNİ İYİLEŞTİREN okuma: Android'de yedekten geri yüklenen şifreli veri,
  /// Keystore anahtarı cihazda olmadığı için çözülemez ve okuma exception
  /// fırlatır — eski davranışta bu, uygulamayı açılışta kilitliyordu
  /// (2026-08-24 dahili test bulgusu). Artık bozuk depo tespit edilince
  /// tamamen temizlenir ve null dönülür; uygulama misafir girişine düşer.
  Future<String?> _readSelfHealing(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      await _wipeCorruptStorage();
      return null;
    } catch (_) {
      await _wipeCorruptStorage();
      return null;
    }
  }

  Future<void> _wipeCorruptStorage() async {
    ApiClient.clearTokenCache();
    try {
      await _storage.deleteAll();
    } catch (_) {
      // Silme de başarısızsa yapacak bir şey yok — null dönüş akışı yine korur.
    }
  }

  Future<void> clearTokens() async {
    ApiClient.clearTokenCache();
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }
}
